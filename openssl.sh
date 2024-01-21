#!/usr/bin/env bash

# Copyright (C) Viktor Szakats. See LICENSE.md
# SPDX-License-Identifier: MIT

# shellcheck disable=SC3040,SC2039
set -o xtrace -o errexit -o nounset; [ -n "${BASH:-}${ZSH_NAME:-}" ] && set -o pipefail

export _NAM _VER _OUT _BAS _DST

_NAM="$(basename "$0" | cut -f 1 -d '.')"; [ -n "${2:-}" ] && _NAM="$2"
_VER="$1"

(
  cd "${_NAM}" || exit 0

  # Required on MSYS2 for pod2man and pod2html in 'make install' phase
  [ "${_HOST}" = 'win' ] && export PATH="${PATH}:/usr/bin/core_perl"

  readonly _ref='CHANGES.md'

  case "${_HOST}" in
    bsd|mac) unixts="$(TZ=UTC stat -f '%m' "${_ref}")";;
    *)       unixts="$(TZ=UTC stat -c '%Y' "${_ref}")";;
  esac

  # Build

  rm -r -f "${_PKGDIR:?}" "${_BLDDIR:?}"

  options=''

  if [ "${_OS}" = 'win' ]; then
    [ "${_CPU}" = 'x86' ] && options+=' mingw'
    [ "${_CPU}" = 'x64' ] && options+=' mingw64'
    if [ "${_CPU}" = 'a64' ]; then
      # Sources:
      # - https://github.com/openssl/openssl/issues/10533
      # - https://github.com/msys2/MINGW-packages/blob/62d5a14c6847bc6c61d7a030c791affc5316842b/mingw-w64-openssl/001-support-aarch64.patch via
      #   https://github.com/msys2/MINGW-packages/commit/f146b20066ff1a357d82866dc0fc2f4b1f4c1648 via
      #   https://github.com/openssl/openssl/commit/b863e1e4c69068e4166bdfbbf9f04bb07991dd40
      echo '## -*- mode: perl; -*-
        my %targets = (
          "mingw-arm64" => {
            inherit_from     => [ "mingw-common" ],
            bn_ops           => add("SIXTY_FOUR_BIT"),
            asm_arch         => "aarch64",
            perlasm_scheme   => "win64",
            multilib         => "64",
          }
        );' > Configurations/11-curl-for-win-mingw-arm64.conf

      options+=' mingw-arm64'
    fi
  elif [ "${_OS}" = 'mac' ]; then
    [ "${_CPU}" = 'x64' ] && options+=' darwin64-x86_64'
    [ "${_CPU}" = 'a64' ] && options+=' darwin64-arm64'
  elif [ "${_OS}" = 'linux' ]; then
    [ "${_CPU}" = 'x64' ] && options+=' linux-x86_64'
    [ "${_CPU}" = 'a64' ] && options+=' linux-aarch64'
    [ "${_CPU}" = 'r64' ] && options+=' linux64-riscv64 no-asm'  # FIXME: disabled ASM to avoid 'AES_set_encrypt_key' relocation errors at link time
  fi

  options+=" ${_LDFLAGS_GLOBAL} ${_CFLAGS_GLOBAL_CMAKE} ${_CFLAGS_GLOBAL} ${_CPPFLAGS_GLOBAL}"
  if [ "${_OS}" = 'win' ]; then
    options+=' -DUSE_BCRYPTGENRANDOM -lbcrypt'
  fi
  [ "${_CPU}" = 'x86' ] || options+=' enable-ec_nistp_64_gcc_128'

  if false; then
    if [ -n "${_ZLIB}" ] && [ -d "../${_ZLIB}/${_PP}" ]; then
      options+=" --with-zlib-lib=${_TOP}/${_ZLIB}/${_PP}/lib"
      options+=" --with-zlib-include=${_TOP}/${_ZLIB}/${_PP}/include"
      options+=' zlib'
    fi
    if [ "${_VER}" != '3.1.4' ]; then
      if [[ "${_DEPS}" = *'brotli'* ]] && [ -d "../brotli/${_PP}" ]; then
        options+=" --with-brotli-lib=${_TOP}/brotli/${_PP}/lib"
        options+=" --with-brotli-include=${_TOP}/brotli/${_PP}/include"
        options+=' brotli'
      fi
      if [[ "${_DEPS}" = *'zstd'* ]] && [ -d "../zstd/${_PP}" ]; then
        options+=" --with-zstd-lib=${_TOP}/zstd/${_PP}/lib"
        options+=" --with-zstd-include=${_TOP}/zstd/${_PP}/include"
        options+=' zstd'
      fi
    fi
  else
    options+=' no-comp'
  fi

  # TODO: consider disabling this option for all musl builds.
  # Workaround for musl builds missing Linux header (as of OpenSSL v3.1.2):
  #   ../crypto/mem_sec.c:60:13: fatal error: linux/mman.h: No such file or directory
  # Linux cross-builds from other systems (e.g. macOS) are unlikely to provide
  # Linux headers.
  if [ "${_CRT}" = 'musl' ] && [ "${_HOST}" != 'linux' ]; then
    options+=' no-secure-memory'
  fi

  # Enabling `no-deprecated` requires walking a fine line. It needs:
  # - libssh2 1.11.1-DEV
  # - curl with an alternate system TLS-backend, it means macOS and Windows
  #   builds with Schannel or SecureTransport enabled, respectively.
  #   or, curl without NTLM support if there is no alternate TLS-backend, e.g. on Linux.
  #   Or, needs building curl without the NTLM feature.
  # - other OpenSSL dependents playing well with `no-deprecated`: gsasl, ngtcp2
  # - other OpenSSL dependents broken with `no-deprecated`: libssh
  if [[ "${_DEPS}" != *'libssh1'* && \
        ( "${_DEPS}" != *'libssh2'* || "${LIBSSH2_VER_}" != '1.11.0' ) && \
        ( \
          "${_OS}" = 'win' || \
        ( "${_OS}" = 'mac' && "${_OSVER}" -lt '1015' ) || \
        ( "${_OS}" = 'linux' && "${_CONFIG}" = *'pico'* )) ]]; then
    options+=' no-deprecated'
  fi

  export CC="${_CC_GLOBAL}"

  # OpenSSL's ./Configure dumps build flags into object `crypto/cversion.o`
  # via `crypto/buildin.h` generated by `util/mkbuildinf.pl`. Thus, whitespace
  # changes, option order/duplicates do change binary output. Options like
  # `--sysroot=` are specific to the build environment, so this feature makes
  # it impossible to create reproducible binaries across build environments.
  # Patch OpenSSL to omit build options from its binary:
  sed -i.bak -E '/mkbuildinf/s/".+/""/' crypto/build.info

  if [ "${_VER}" = '3.1.4' ]; then
    # Patch OpenSSL ./Configure to:
    # - make it accept Windows-style absolute paths as --prefix. Without the
    #   patch it misidentifies all such absolute paths as relative ones and
    #   aborts.
    #   Reported: https://github.com/openssl/openssl/issues/9520
    #   Fixed in OpenSSL 3.2.0.
    # - allow no-apps option to save time building openssl command-line tool.
    #   Fixed in OpenSSL 3.2.0.
    sed \
      -e 's/die "Directory given with --prefix/print "Directory given with --prefix/g' \
      -e 's/"aria",$/"apps", "aria",/g' \
      < ./Configure > ./Configure-patched
    chmod a+x ./Configure-patched
    mv ./Configure-patched ./Configure
  fi

  if [ "${_OS}" = 'win' ]; then
    # Space or backslash not allowed. Needs to be a folder restricted
    # to Administrators across Windows installations, versions and
    # configurations. We do avoid using the new default prefix set since
    # OpenSSL 1.1.1d, because by using the C:\Program Files*\ value, the
    # prefix remains vulnerable on localized Windows versions. The default
    # below gives a "more secure" configuration for most Windows installations.
    # The secure solution would be to disable loading anything from hard-coded
    # paths and preferably to detect OS location at runtime and adjust config
    # paths accordingly; none supported by OpenSSL.
    _my_prefix='C:/Windows/System32/OpenSSL'
    if [ "${_OS}" != "${_HOST}" ] && [ "${_VER}" != '3.1.4' ]; then
      # Hack to skip (mis-)checking for an absolute prefix using unixy rules
      # while cross-building on a *nix host for Windows. For that, we must
      # pass a non-empty CROSS_COMPILE value while making sure that
      # CROSS_COMPILE + CC points to our compiler. Take extra care of the
      # compiler options we must pass to OpenSSL in the CC value.
      export CROSS_COMPILE
      CROSS_COMPILE="$(dirname "$(command -v "$(echo "${CC}" | cut -d ' ' -f 1)")")/"
    fi
  else
    _my_prefix='/etc'
  fi
  _ssldir='ssl'

  if [ "${_VER}" != '3.1.4' ]; then
    # no-quic: disable OpenSSL's own (non-quictls-compatible) QUIC API.
    # no-sm2-precomp: avoid a 3.2.0 optimization that makes libcrypto 0.5MB larger.
    options+=' no-docs no-quic no-sm2-precomp'
  fi

  # 'no-dso' implies 'no-dynamic-engine' which in turn compiles in these
  # engines non-dynamically. To avoid them, also set `no-engine`.
  (
    mkdir "${_BLDDIR}"; cd "${_BLDDIR}"
    # shellcheck disable=SC2086
    ../Configure ${options} \
      no-filenames \
      no-legacy \
      no-apps \
      no-autoload-config \
      no-engine \
      no-module \
      no-dso \
      no-shared \
      no-srp no-nextprotoneg \
      no-bf no-rc4 no-cast \
      no-idea no-cmac no-rc2 no-mdc2 no-whirlpool \
      no-dsa \
      no-tests \
      no-makedepend \
      "--prefix=${_my_prefix}" \
      "--openssldir=${_ssldir}"
  )

  SOURCE_DATE_EPOCH="${unixts}" TZ=UTC make --directory="${_BLDDIR}" --jobs="${_JOBS}"
  # Ending slash required.
  make --directory="${_BLDDIR}" --jobs="${_JOBS}" install "DESTDIR=$(pwd)/${_PKGDIR}/" >/dev/null # 2>&1

  # OpenSSL 3.x does not strip the drive letter anymore:
  #   ./openssl/${_PKGDIR}/C:/Windows/System32/OpenSSL
  # Some tools (e.g. CMake) become weird when colons appear in a filename,
  # so move results to a sane, standard path:

  mkdir -p "./${_PP}"
  mv "${_PKGDIR}/${_my_prefix}"/* "${_PP}"

  # Rename 'lib64' to 'lib'. This is what most packages expect.
  # Not using '--libdir=lib' because that also changes the paths hardwired
  # into the binaries, making them different from default builds at runtime.
  if [ -d "${_PP}/lib64" ]; then
    mv "${_PP}/lib64" "${_PP}/lib"
  fi

  # Delete .pc files
  rm -r -f "${_PP}"/lib/pkgconfig

  # List files created
  find "${_PP}" | grep -a -v -F '/share/' | sort

  # Make steps for determinism

  # shellcheck disable=SC2086
  "${_STRIP_LIB}" ${_STRIPFLAGS_LIB} "${_PP}"/lib/*.a

  touch -c -r "${_ref}" "${_PP}"/include/openssl/*.h
  touch -c -r "${_ref}" "${_PP}"/lib/*.a

  # Create package

  _OUT="${_NAM}-${_VER}${_REVSUFFIX}${_PKGSUFFIX}"
  _BAS="${_NAM}-${_VER}${_PKGSUFFIX}"
  _DST="$(pwd)/_pkg"; rm -r -f "${_DST}"

  mkdir -p "${_DST}/include/openssl"
  mkdir -p "${_DST}/lib"

  cp -f -p "${_PP}"/include/openssl/*.h "${_DST}/include/openssl/"
  cp -f -p "${_PP}"/lib/*.a             "${_DST}/lib"
  cp -f -p CHANGES.md                   "${_DST}/"
  cp -f -p LICENSE.txt                  "${_DST}/"
  cp -f -p README.md                    "${_DST}/"
  cp -f -p FAQ.md                       "${_DST}/"
  cp -f -p NEWS.md                      "${_DST}/"

  [ "${_NAM}" = 'quictls' ] && cp -f -p README-OpenSSL.md "${_DST}/"

  ../_pkg.sh "$(pwd)/${_ref}"
)
