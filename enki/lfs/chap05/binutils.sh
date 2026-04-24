#/bin/bash

echo '****' Compiling binutils

PACKAGE=binutils-2.46.0

if [ -f /mnt/lfs/tools/bin/x86_64-lfs-linux-gnu-as ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd $LFS/sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

rm -rf build
mkdir -v build
cd       build

../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu

make

make install

cd $LFS/sources
rm -rf $LFS/sources/$PACKAGE
