#/bin/bash

echo '****' "Building libcap"

PACKAGE=libcap-2.77
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

sed -i '/install -m.*STA/d' libcap/Makefile

make prefix=/usr lib=lib

make test

if [ $? -eq 1 ]; then
    echo "check failed"
    exit 255
fi

make prefix=/usr lib=lib install

touch $FLAGcd /sources
rm -rf $PACKAGE
