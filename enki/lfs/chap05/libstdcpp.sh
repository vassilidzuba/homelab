#/bin/bash

echo '****' Compiling libstdc++

PACKAGE=gcc-15.2.0

cd $LFS/sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

if [ -f /mnt/lfs/usr/lib/libstdc++.so ]; then
  echo "Library libstdc++ already built"
  exit 0
fi

cd $PACKAGE

rm -rf build
mkdir -v build
cd       build

../libstdc++-v3/configure      \
    --host=$LFS_TGT            \
    --build=$(../config.guess) \
    --prefix=/usr              \
    --disable-multilib         \
    --disable-nls              \
    --disable-libstdcxx-pch    \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.2.0

make

make DESTDIR=$LFS install

rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la

cd $LFS/sources
rm -rf $PACKAGE
