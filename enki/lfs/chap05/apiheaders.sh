#/bin/bash

echo '****' Installing headers

PACKAGE=linux-6.19.11


if [ -f /mnt/lfs/usr/include/linux/const.h ]; then
  echo "Headers from $PACKAGE already installed"
  exit 0
fi

cd $LFS/sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

make mrproper

make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr


cd $LFS/sources
rm -rf $LFS/sources/$PACKAGE
