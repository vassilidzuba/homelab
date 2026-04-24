#/bin/bash

echo '****' Compiling make

PACKAGE=make-4.4.1

if [ -f /mnt/lfs/usr/bin/make ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd $LFS/sources

if [ ! -d $PACKAGE ]; then
  tar xvzf $PACKAGE.tar.gz
fi

cd $PACKAGE

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install


cd $LFS/sources
rm -rf $LFS/sources/$PACKAGE
