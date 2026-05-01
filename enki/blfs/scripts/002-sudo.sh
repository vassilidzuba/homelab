#!/bin/bash


if [ "$SHAREDDIR" = "" ]; then
    echo 'Variable $SHAREDDIR should be defined'
    exit 255
fi

PACKAGE=sudo-1.9.17p2
FLAG=/lfsflags/blfs/$PACKAGE
SOURCE=sudo-1.9.17p2.tar.gz

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

./configure --prefix=/usr         \
            --libexecdir=/usr/lib \
            --with-secure-path    \
            --with-env-editor     \
            --docdir=/usr/share/doc/sudo-1.9.17p2 \
            --with-passprompt="[sudo] password for %p: "

make

env LC_ALL=C make check |& tee make-check.log

make install

if [ ! -f /etc/sudoers.d/00-sudo ]; then
    cp $SHAREDDIR/etc/sudoers.d/00-sudo /etc/sudoers.d
fi

touch $FLAG
cd /sources
rm -rf $PACKAGE
