#/bin/bash

echo '****' Compiling diffutils

PACKAGE=diffutils-3.12

if [ -f /mnt/lfs/usr/bin/diff ]; then
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
            gl_cv_func_strcasecmp_works=y \
            --build=$(./build-aux/config.guess)time

make

make DESTDIR=$LFS install


cd $LFS/sources
rm -rf $LFS/sources/$PACKAGE
