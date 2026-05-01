#!/bin/bash


if [ "$SHAREDDIR" = "" ]; then
    echo 'Variable $SHAREDDIR should be defined'
    exit 255
fi

PACKAGE=nano-8.7.1
FLAG=/lfsflags/blfs/$PACKAGE
SOURCE=nano-8.7.1.tar.xz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-8.7.1 &&
make

if [ "$?" != 0 ]; then
    echo "Build of $PACKAGE failed"
    exit 255
fi

sudo make install &&
sudo install -v -m644 doc/{nano.html,sample.nanorc} /usr/share/doc/nano-8.7.1

touch $FLAG
cd /sources
rm -rf $PACKAGE
