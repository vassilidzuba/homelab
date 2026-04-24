#/bin/bash

echo '****' "Building m4"

PACKAGE=m4-1.4.21
FLAG=/lfsflags/chap08/$PACKAGE

if [ -f $FLAG ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

./configure --prefix=/usr

make

make check

if [ $? -eq 1 ]; then
    echo "check failed"
    exit 255
fi

make install

touch $FLAGcd /sources
rm -rf $PACKAGE
