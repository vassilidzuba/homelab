#/bin/bash

echo '****' Compiling findutils

PACKAGE=findutils-4.10.0


if [ -f /mnt/lfs/usr/bin/find ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd $LFS/sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

cd $LFS/sources
rm -rf $LFS/sources/$PACKAGE
