#/bin/bash

echo '****' "Building acl"

PACKAGE=acl-2.3.2
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
            --docdir=/usr/share/doc/acl-2.3.2

make

make check

if [ $? -eq 1 ]; then
    echo "check failed"
    exit 255
fi

make install

touch $FLAG
cd /sources
rm -rf $PACKAGE
