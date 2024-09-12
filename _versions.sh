#!/bin/sh

# Copyright (C) Viktor Szakats. See LICENSE.md
# SPDX-License-Identifier: MIT

export DOCKER_IMAGE='debian:testing-20240904-slim'

export CURL_VER_='8.10.0'
export CURL_HASH=e6b142f0e85e954759d37e26a3627e2278137595be80e3a860c4353e4335e5a0
# Create revision string
# NOTE: Set _REV to 1 after bumping CURL_VER_, then increment for each
#       CI rebuild via `main` branch push (e.g. after bumping a dependency).
export _REV="${CW_REVISION:-1}"

export TRURL_VER_='0.15'
export TRURL_HASH=e58d9a698c009b2b1381f5636b5334ce7704ad2cd5ae8d30da97d483518a7f25

export CACERT_VER_='2024-07-02'
export CACERT_HASH=1bf458412568e134a4514f5e170a328d11091e071c7110955c9884ed87972ac9
export BROTLI_VER_='1.1.0'
export BROTLI_HASH=e720a6ca29428b803f4ad165371771f5398faba397edf6778837a18599ea13ff
export CARES_VER_='1.33.1'
export CARES_HASH=06869824094745872fa26efd4c48e622b9bd82a89ef0ce693dc682a23604f415
export LIBPSL_VER_='0.21.5'
export LIBPSL_HASH=1dcc9ceae8b128f3c0b3f654decd0e1e891afc6ff81098f227ef260449dae208
export LIBSSH_VER_='0.11.1'
export LIBSSH_HASH=14b7dcc72e91e08151c58b981a7b570ab2663f630e7d2837645d5a9c612c1b79
export LIBSSH2_VER_='1.11.0'
export LIBSSH2_HASH=a488a22625296342ddae862de1d59633e6d446eff8417398e06674a49be3d7c2
export LIBSSH2_CPPFLAGS='-DLIBSSH2_NO_BLOWFISH -DLIBSSH2_NO_RC4 -DLIBSSH2_NO_HMAC_RIPEMD -DLIBSSH2_NO_CAST -DLIBSSH2_NO_3DES -DLIBSSH2_NO_MD5'
export NGHTTP2_VER_='1.63.0'
export NGHTTP2_HASH=4879c75dd32a74421b9857924449460b8341796c0613ba114ab2188e4622354b
export NGHTTP3_VER_='1.5.0'
export NGHTTP3_HASH=8c00e3910ea2ad1218dafebcf8dd2ffdf030c992d9ceb65834d29e5e5278dd0d
export NGTCP2_VER_='1.7.0'
export NGTCP2_HASH=e07c79090f96f6738fabab2129657c53f0cc05164de3662592581ca5425617b1
export QUICTLS_VER_='3.1.5'
export QUICTLS_HASH=a9d261a0a85d141052534aac3f67872093e37c004255eb4288df52f3beaf6e6f
export OPENSSL_VER_='3.3.2'
export OPENSSL_HASH=2e8a40b01979afe8be0bbfb3de5dc1c6709fedb46d6c89c10da114ab5fc3d281
export BORINGSSL_VER_='e724ef02089bf2bb494203231fc5cb62acc2fad6'
export BORINGSSL_HASH=d73c95f99e868a62802dea2834a48e3611e7a19128395dd940bbba7447917930
export LIBRESSL_VER_='3.9.2'
export LIBRESSL_HASH=7b031dac64a59eb6ee3304f7ffb75dad33ab8c9d279c847f92c89fb846068f97
export OSSLSIGNCODE_VER_='2.9.0'
export OSSLSIGNCODE_HASH=3fe5488e442ad99f91410efeb7b029275366b5df9aa02371dcc89a8f8569ff55
export ZLIBNG_VER_='2.2.1'
export ZLIBNG_HASH=ec6a76169d4214e2e8b737e0850ba4acb806c69eeace6240ed4481b9f5c57cdf
export ZLIB_VER_='1.3.1'
export ZLIB_HASH=38ef96b8dfe510d42707d9c781877914792541133e1870841463bfa73f883e32
export ZSTD_VER_='1.5.6'
export ZSTD_HASH=8c29e06cf42aacc1eafc4077ae2ec6c6fcb96a626157e0593d5e82a34fd403c1
export LLVM_MINGW_LINUX_AARCH64_VER_='20240619'
export LLVM_MINGW_LINUX_AARCH64_HASH=050c22b213cb8e99e7f1bdb83fd9b96a403541bb768188bea71396e65a45c611
export LLVM_MINGW_LINUX_X86_64_VER_='20240619'
export LLVM_MINGW_LINUX_X86_64_HASH=27d33157cc252c29ad6f777a96a0d94176fea1b534ff09b5071485def143b90e
export LLVM_MINGW_MAC_VER_='20240619'
export LLVM_MINGW_MAC_HASH=604b73b758bb3e5369373073f9d2e452509c8e6db8b005e0a1e6a04da1787bb3
export LLVM_MINGW_WIN_VER_='20240619'
export LLVM_MINGW_WIN_HASH=810703594a7e3eea03385b5329c7ea3bd65f5e496b44cf1b68c17ff436d265e7
