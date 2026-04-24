#/bin/bash

echo '****' Compiling tar

PACKAGE=tar-1.35


if [ -f /mnt/lfs/usr/bin/tar ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

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
