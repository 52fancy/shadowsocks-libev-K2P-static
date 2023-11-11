#!/bin/bash

set -e
set -x

prefix=/opt/projects
MAKE="make -j`nproc`"
LDFLAGS="-Wl,-static -static -static-libgcc"
CFLAGS="-mtune=mips32 -mips32 -O3 -ffunction-sections -fdata-sections"
CONFIGURE="./configure --host=mipsel-linux-uclibc"

wget https://github.com/52fancy/shadowsocks-libev-K2P-static/raw/main/pcre-8.45.tar.gz
tar -zxvf pcre-8.45.tar.gz
cd pcre-8.45
LDFLAGS="-L$prefix/pcre/lib $LDFLAGS" \
CFLAGS="-I$prefix/pcre/include $CFLAGS" \
CXXFLAGS=$CFLAGS \
$CONFIGURE \
--prefix=$prefix/pcre \
--enable-unicode-properties \
--enable-utf8 \
--disable-shared
$MAKE && make install

cd -
wget https://github.com/52fancy/shadowsocks-libev-K2P-static/raw/main/mbedtls-2.25.0.tar.gz
tar -zxvf mbedtls-2.25.0.tar.gz
cd mbedtls-2.25.0
cmake \
-DCMAKE_INSTALL_PREFIX=$prefix/mbedtls \
-DCMAKE_C_COMPILER=`which mipsel-linux-uclibc-gcc` \
-DCMAKE_C_FLAGS="-I$prefix/mbedtls/include $CFLAGS" \
-DCMAKE_EXE_LINKER_FLAGS="-L$prefix/mbedtls/lib $LDFLAGS" \
./
$MAKE && make install

cd - 
wget https://github.com/52fancy/shadowsocks-libev-K2P-static/raw/main/libsodium-1.0.18.tar.gz
tar -zxvf libsodium-1.0.18.tar.gz
cd libsodium-1.0.18
LDFLAGS="-L$prefix/libsodium/lib $LDFLAGS" \
CFLAGS="-I$prefix/libsodium/include $CFLAGS" \
CXXFLAGS=$CFLAGS \
$CONFIGURE \
--prefix=$prefix/libsodium \
--enable-minimal \
--enable-static \
--disable-shared
$MAKE && make install

cd - 
wget https://github.com/52fancy/shadowsocks-libev-K2P-static/raw/main/c-ares-1.17.1.tar.gz
tar -zxvf c-ares-1.17.1.tar.gz
cd c-ares-1.17.1
LDFLAGS="-L$prefix/c-ares/lib $LDFLAGS" \
CFLAGS="-I$prefix/c-ares/include $CFLAGS" \
CXXFLAGS=$CFLAGS \
$CONFIGURE \
--prefix=$prefix/c-ares \
--disable-shared
$MAKE && make install

cd -
wget https://github.com/52fancy/shadowsocks-libev-K2P-static/raw/main/libev-4.33.tar.gz
tar -zxvf libev-4.33.tar.gz
cd libev-4.33
wget https://github.com/52fancy/shadowsocks-libev-K2P-static/raw/main/libev.patch
patch -p1 < libev.patch
LDFLAGS="-L$prefix/libev/lib $LDFLAGS" \
CFLAGS="-I$prefix/libev/include $CFLAGS" \
CXXFLAGS=$CFLAGS \
$CONFIGURE \
--prefix=$prefix/libev \
--disable-shared
$MAKE && make install

cd -
wget https://github.com/52fancy/shadowsocks-libev-K2P-static/raw/main/shadowsocks-libev-3.3.5.tar.gz
tar -zxvf shadowsocks-libev-3.3.5.tar.gz
cd shadowsocks-libev-3.3.5
LIBS="-lpthread -lm" \
LDFLAGS="-L$prefix/libev/lib -L$prefix/c-ares/lib $LDFLAGS" \
CFLAGS="-I$prefix/libev/include -I$prefix/c-ares/include $CFLAGS" \
CXXFLAGS=$CFLAGS \
$CONFIGURE \
--prefix=$prefix/shadowsocks-libev \
--with-pcre=$prefix/pcre \
--with-mbedtls=$prefix/mbedtls \
--with-sodium=$prefix/libsodium \
--with-cares=$prefix/c-ares \
--with-ev==$prefix/libev \
--disable-ssp \
--disable-documentation
$MAKE && make install
mipsel-linux-uclibc-strip -s $prefix/shadowsocks-libev/bin/*
