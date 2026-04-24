#/bin/bash

echo '****' "Building bc"

PACKAGE=bc-7.0.3
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

CC='gcc -std=c99' ./configure --prefix=/usr -G -O3 -r

make

make test

if [ $? -eq 1 ]; then
    echo "check failed"
    exit 255
fi


make install

touch $FLAGcd /sources
rm -rf $PACKAGE
