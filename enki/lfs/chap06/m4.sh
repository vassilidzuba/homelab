#/bin/bash

echo '****' Compiling m4

PACKAGE=m4-1.4.21

cd $LFS/sources

if [ -f /mnt/lfs/usr/bin/m4 ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install


cd $LFS/sources
rm -rf $LFS/sources/$PACKAGE
