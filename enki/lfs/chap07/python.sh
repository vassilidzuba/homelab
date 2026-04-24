#/bin/bash

echo '****' "Compiling python"

PACKAGE=Python-3.14.3

if [ -f /usr/bin/python3 ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

./configure --prefix=/usr       \
            --enable-shared     \
            --without-ensurepip \
            --without-static-libpython

make

make install

cd /sources
rm -rf $PACKAGE
