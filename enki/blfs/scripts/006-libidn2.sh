#!/bin/bash


if [ "$SHAREDDIR" = "" ]; then
    echo 'Variable $SHAREDDIR should be defined'
    exit 255
fi

PACKAGE=libidn2-2.3.8
FLAG=/lfsflags/blfs/$PACKAGE
SOURCE=libidn2-2.3.8.tar.gz

if [ -f "$FLAG" ]; then
    echo "Package $PACKAGE is already built."
    exit 255
fi

if [ ! -f "/sources/$SOURCE" ]; then
    cp "$SHAREDDIR/$SOURCE" /sources
fi

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvzf $SOURCE
  if [ $? -eq 1 ]; then
      echo "unable to extract archive"
      exit 255
  fi
fi

cd $PACKAGE

./configure --prefix=/usr --disable-static &&
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
