#!/bin/bash


if [ "$SHAREDDIR" = "" ]; then
    echo 'Variable $SHAREDDIR should be defined'
    exit 255
fi

PACKAGE=libunistring-1.4.1
FLAG=/lfsflags/blfs/$PACKAGE
SOURCE=libunistring-1.4.1.tar.xz

if [ -f "$FLAG" ]; then
    echo "Package $PACKAGE is already built."
    exit 255
fi

if [ ! -f "/sources/$SOURCE" ]; then
    cp "$SHAREDDIR/$SOURCE" /sources
fi

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $SOURCE
  if [ $? -eq 1 ]; then
      echo "unable to extract archive"
      exit 255
  fi
fi

cd $PACKAGE

sed -r '/_GL_EXTERN_C/s/w?memchr|bsearch/(&)/' \
    -i $(find -name \*.in.h)

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libunistring-1.4.1 &&
make

if [ "$?" != 0 ]; then
    echo "Build of $PACKAGE failed"
    exit 255
fi

sudo make install
if [ "$?" != 0 ]; then
    echo "Install of $PACKAGE failed"
    exit 255
fi


touch $FLAG
cd /sources
rm -rf $PACKAGE
