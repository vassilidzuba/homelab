#/bin/bash

echo '****' Compiling bash

PACKAGE=bash-5.3

if [ -f /mnt/lfs/usr/bin/bash ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd $LFS/sources

if [ ! -d $PACKAGE ]; then
  tar xvzf $PACKAGE.tar.gz
fi

cd $PACKAGE

./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc

make

make DESTDIR=$LFS install

ln -sv bash $LFS/bin/sh


cd $LFS/sources
rm -rf $LFS/sources/$PACKAGE
