#/bin/bash

echo '****' Compiling gzip

PACKAGE=gzip-1.14

if [ -f /mnt/lfs/usr/bin/gzip ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd $LFS/sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

./configure --prefix=/usr --host=$LFS_TGT

make

make DESTDIR=$LFS install



cd $LFS/sources
rm -rf $LFS/sources/$PACKAGE
