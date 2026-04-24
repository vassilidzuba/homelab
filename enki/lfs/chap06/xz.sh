#/bin/bash

echo '****' Compiling xz

PACKAGE=xz-5.8.2

if [ -f /mnt/lfs/usr/bin/xz ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd $LFS/sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.8.2

make

make DESTDIR=$LFS install

rm -v $LFS/usr/lib/liblzma.la


cd $LFS/sources
rm -rf $LFS/sources/$PACKAGE
