#/bin/bash

echo '****' Compiling gawk

PACKAGE=gawk-5.3.2

if [ -f /mnt/lfs/usr/bin/gawk ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd $LFS/sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install


cd $LFS/sources
rm -rf $LFS/sources/$PACKAGE
