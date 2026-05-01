#!/bin/bash


if [ "$SHAREDDIR" = "" ]; then
    echo 'Variable $SHAREDDIR should be defined'
    exit 255
fi

PACKAGE=libpsl-0.21.5
FLAG=/lfsflags/blfs/$PACKAGE
SOURCE=libpsl-0.21.5.tar.gz

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

mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release &&

ninja

if [ "$?" != 0 ]; then
    echo "Build of $PACKAGE failed"
    exit 255
fi

sudo ninja install
if [ "$?" != 0 ]; then
    echo "Install of $PACKAGE failed"
    exit 255
fi


touch $FLAG
cd /sources
rm -rf $PACKAGE
