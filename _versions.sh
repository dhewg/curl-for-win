#!/bin/sh

# NOTE: Bump nghttp3 and ngtcp2 together with curl.

export CURL_VER_='7.84.0'
export CURL_HASH=2d118b43f547bfe5bae806d8d47b4e596ea5b25a6c1f080aef49fbcd817c5db8
export BROTLI_VER_='1.0.9'
export BROTLI_HASH=f9e8d81d0405ba66d181529af42a3354f838c939095ff99930da6aa9cdf6fe46
export LIBGSASL_VER_='1.10.0'
export LIBGSASL_HASH=f1b553384dedbd87478449775546a358d6f5140c15cccc8fb574136fdc77329f
export LIBUNISTRING_VER_='1.0'
export LIBUNISTRING_HASH=5bab55b49f75d77ed26b257997e919b693f29fd4a1bc22e0e6e024c246c72741
export LIBICONV_VER_='1.17'
export LIBICONV_HASH=8f74213b56238c85a50a5329f77e06198771e70dd9a739779f4c02f65d971313
export LIBIDN2_VER_='2.3.3'
export LIBIDN2_HASH=f3ac987522c00d33d44b323cae424e2cffcb4c63c6aa6cd1376edacbf1c36eb0
export LIBPSL_VER_='0.21.1'
export LIBPSL_HASH=ac6ce1e1fbd4d0254c4ddb9d37f1fa99dec83619c1253328155206b896210d4c
export LIBSSH2_VER_='1.10.0'
export LIBSSH2_HASH=2d64e90f3ded394b91d3a2e774ca203a4179f69aebee03003e5a6fa621e41d51
export NGHTTP2_VER_='1.48.0'
export NGHTTP2_HASH=47d8f30ee4f1bc621566d10362ca1b3ac83a335c63da7144947c806772d016e4
export NGHTTP3_VER_='0.5.0'
export NGHTTP3_HASH=017c56dea814c973a15962c730840d33c6ecbfa92535236df3d5b66f0cb08de0
export NGTCP2_VER_='0.6.0'
export NGTCP2_HASH=7f88db4fb40af9838ed7655899606431d746988a2a19904cab8f95c134fcd78a
export OPENSSL_QUIC_VER_='3.0.5'
export OPENSSL_QUIC_HASH=766878d2c97d13ea36254ae3b1bf553939ac111f3f1b3449b8d777aca7671366
export OPENSSL_VER_='3.0.5'
export OPENSSL_HASH=aa7d8d9bef71ad6525c55ba11e5f4397889ce49c2c9349dcea6d3e4f0b024a7a
export BORINGSSL_VER_='7528f03c8ad73216f462f86e1d64d3d780a5cd42'
export BORINGSSL_HASH=c244fb7fb4158ec01c9c498436a9acb0bb3692c80645bb7a8417f32d62d0bbd5
export LIBRESSL_VER_='3.5.3'
export LIBRESSL_HASH=3ab5e5eaef69ce20c6b170ee64d785b42235f48f2e62b095fca5d7b6672b8b28
export ZLIB_VER_='1.2.12'
export ZLIB_HASH=7db46b8d7726232a621befaab4a1c870f00a90805511c0e0090441dac57def18
export ZSTD_VER_='1.5.2'
export ZSTD_HASH=7c42d56fac126929a6a85dbc73ff1db2411d04f104fae9bdea51305663a83fd0
export LLVM_MINGW_LINUX_VER_='20220323'
export LLVM_MINGW_LINUX_HASH=6d69ab28a3a9a2b7159178ff11cae8545fd44c9343573900fcf60434539695d8
export LLVM_MINGW_MAC_VER_="${LLVM_MINGW_LINUX_VER_}"
export LLVM_MINGW_MAC_HASH=5ccfd9ebe3ecf4b1f682cc3303af93e70b7977c86e32faa8e0c212e8f674b8cd
export LLVM_MINGW_WIN_VER_="${LLVM_MINGW_LINUX_VER_}"
export LLVM_MINGW_WIN_HASH=3014a95e4ec4d5c9d31f52fbd6ff43174a0d9c422c663de7f7be8c2fcc9d837a
export PEFILE_VER_='2022.5.30'

# Create revision string
# NOTE: Set _REV to empty after bumping CURL_VER_, and
#       set it to 1 then increment by 1 each time bumping a dependency
#       version or pushing a CI rebuild for the main branch.
export _REV='5'
