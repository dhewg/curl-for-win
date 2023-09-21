#!/bin/sh

# Copyright (C) Viktor Szakats. See LICENSE.md
# SPDX-License-Identifier: MIT

# NOTE: Bump nghttp3 and ngtcp2 together with curl.

export DOCKER_IMAGE='debian:testing-20230919-slim'

export CURL_VER_='8.3.0'
export CURL_HASH=376d627767d6c4f05105ab6d497b0d9aba7111770dd9d995225478209c37ea63
# Create revision string
# NOTE: Set _REV to 1 after bumping CURL_VER_, then increment for each
#       CI rebuild via `main` branch push (e.g. after bumping a dependency).
export _REV="${CW_REVISION:-2}"

export CACERT_VER_='2023-08-22'
export CACERT_HASH=23c2469e2a568362a62eecf1b49ed90a15621e6fa30e29947ded3436422de9b9
export BROTLI_VER_='1.1.0'
export BROTLI_HASH=e720a6ca29428b803f4ad165371771f5398faba397edf6778837a18599ea13ff
export CARES_VER_='1.19.1'
export CARES_HASH=321700399b72ed0e037d0074c629e7741f6b2ec2dda92956abe3e9671d3e268e
export GSASL_VER_='2.2.0'
export GSASL_HASH=79b868e3b9976dc484d59b29ca0ae8897be96ce4d36d32aed5d935a7a3307759
export LIBIDN2_VER_='2.3.4'
export LIBIDN2_HASH=93caba72b4e051d1f8d4f5a076ab63c99b77faee019b72b9783b267986dbb45f
export LIBUNISTRING_VER_='1.1'
export LIBUNISTRING_HASH=827c1eb9cb6e7c738b171745dac0888aa58c5924df2e59239318383de0729b98
export LIBICONV_VER_='1.17'
export LIBICONV_HASH=8f74213b56238c85a50a5329f77e06198771e70dd9a739779f4c02f65d971313
export LIBPSL_VER_='0.21.2'
export LIBPSL_HASH=e35991b6e17001afa2c0ca3b10c357650602b92596209b7492802f3768a6285f
export WOLFSSH_VER_='1.4.13'
export WOLFSSH_HASH=95de536d2390ca4a8a7f9be4b2faaaebb61dcedf2c6571107172d4a64347421c
export LIBSSH_VER_='0.10.5'
export LIBSSH_HASH=b60e2ff7f367b9eee2b5634d3a63303ddfede0e6a18dfca88c44a8770e7e4234
export LIBSSH2_VER_='1.11.0'
export LIBSSH2_HASH=a488a22625296342ddae862de1d59633e6d446eff8417398e06674a49be3d7c2
export LIBSSH2_CPPFLAGS='-DLIBSSH2_NO_DSA -DLIBSSH2_NO_BLOWFISH -DLIBSSH2_NO_RC4 -DLIBSSH2_NO_HMAC_RIPEMD -DLIBSSH2_NO_CAST -DLIBSSH2_NO_3DES -DLIBSSH2_NO_MD5'
export NGHTTP2_VER_='1.56.0'
export NGHTTP2_HASH=65eee8021e9d3620589a4a4e91ce9983d802b5229f78f3313770e13f4d2720e9
export NGHTTP3_VER_='0.15.0'
export NGHTTP3_HASH=20d33a364033a99de11a14246fffc3e059e133cf3a53b0891f6785c929f257f1
export NGTCP2_VER_='0.19.1'
export NGTCP2_HASH=597d29f2f72e63217a0c5a8b6d1b04c994cf011564bf9f94142701edb977bf6e
export WOLFSSL_VER_='5.6.3'
export WOLFSSL_HASH=2e74a397fa797c2902d7467d500de904907666afb4ff80f6464f6efd5afb114a
export MBEDTLS_VER_='3.4.1'
export MBEDTLS_HASH=a420fcf7103e54e775c383e3751729b8fb2dcd087f6165befd13f28315f754f5
export QUICTLS_VER_='3.1.2'
export QUICTLS_HASH=d3e07211e6b76ac835f1ff5787d42af663fbc62e4e42ec14777deec0f53d1627
export OPENSSL_VER_='3.1.3'
export OPENSSL_HASH=f0316a2ebd89e7f2352976445458689f80302093788c466692fb2a188b2eacf6
export BORINGSSL_VER_='a1843d660b47116207877614af53defa767be46a'
export BORINGSSL_HASH=af0b56e882b1af3939385a9ea03bd2b738c619534424eaac20fef1ebe47c5b54
export LIBRESSL_VER_='3.7.3'
export LIBRESSL_HASH=7948c856a90c825bd7268b6f85674a8dcd254bae42e221781b24e3f8dc335db3
export ZLIBNG_VER_='2.1.3'
export ZLIBNG_HASH=d20e55f89d71991c59f1c5ad1ef944815e5850526c0d9cd8e504eaed5b24491a
export ZLIB_VER_='1.3'
export ZLIB_HASH=8a9ba2898e1d0d774eca6ba5b4627a11e5588ba85c8851336eb38de4683050a7
export ZSTD_VER_='1.5.5'
export ZSTD_HASH=9c4396cc829cfae319a6e2615202e82aad41372073482fce286fac78646d3ee4
if [ "${_BRANCH#*dev*}" != "${_BRANCH}" ]; then
export LLVM_MINGW_LINUX_AARCH64_VER_='20230919'
export LLVM_MINGW_LINUX_AARCH64_HASH=59122a626c13948256716e2db25877fd745fca9a26eee2ba78721607812fee5e
export LLVM_MINGW_LINUX_X86_64_VER_='20230919'
export LLVM_MINGW_LINUX_X86_64_HASH=b39c1d5b6ccbe2e0547f7189c696c89a235c2d6b61106d2a0b4cb1e2cc55f328
export LLVM_MINGW_MAC_VER_='20230919'
export LLVM_MINGW_MAC_HASH=0112e27ceaed23143e99cf00111cda2388eb4671bda38902b2841ba8875a7fc1
export LLVM_MINGW_WIN_VER_='20230919'
export LLVM_MINGW_WIN_HASH=78f2a8402e8f5629803d895077bfd7a13f5c2dcad733c86cf798d0ddffe3813a
else
export LLVM_MINGW_LINUX_AARCH64_VER_='20230919'
export LLVM_MINGW_LINUX_AARCH64_HASH=59122a626c13948256716e2db25877fd745fca9a26eee2ba78721607812fee5e
export LLVM_MINGW_LINUX_X86_64_VER_='20230919'
export LLVM_MINGW_LINUX_X86_64_HASH=b39c1d5b6ccbe2e0547f7189c696c89a235c2d6b61106d2a0b4cb1e2cc55f328
export LLVM_MINGW_MAC_VER_='20230919'
export LLVM_MINGW_MAC_HASH=0112e27ceaed23143e99cf00111cda2388eb4671bda38902b2841ba8875a7fc1
export LLVM_MINGW_WIN_VER_='20230919'
export LLVM_MINGW_WIN_HASH=78f2a8402e8f5629803d895077bfd7a13f5c2dcad733c86cf798d0ddffe3813a
fi
