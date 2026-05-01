#!/bin/bash


if [ "$SHAREDDIR" = "" ]; then
    echo 'Variable $SHAREDDIR should be defined'
    exit 255
fi

PACKAGE=cmake-4.2.3
FLAG=/lfsflags/blfs/$PACKAGE
SOURCE=cmake-4.2.3.tar.gz

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

sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake &&

./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-cppdap   \
            --no-system-librhash \
            --no-system-curl     \
            --no-system-libarchive   \
            --no-system-libuv \
            --docdir=/share/doc/cmake-4.2.3 &&
make

bin/ctest -j2

sudo make install

touch $FLAG
cd /sources
rm -rf $PACKAGE
