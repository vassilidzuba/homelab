#/bin/bash

echo '****' "Building xz"

PACKAGE=xz-5.8.2
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

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.8.2

make

make check

make install


touch $FLAGcd /sources
rm -rf $PACKAGE
