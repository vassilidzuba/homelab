#/bin/bash

echo '****' Compiling sed

if [ -f /mnt/lfs/usr/bin/sed ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

PACKAGE=sed-4.9

cd $LFS/sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)
make

make DESTDIR=$LFS install

cd $LFS/sources
rm -rf $LFS/sources/$PACKAGE
