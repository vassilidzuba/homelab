#/bin/bash

echo '****' "Compiling texinfo"

PACKAGE=texinfo-7.2

if [ -f /usr/bin/info ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

./configure --prefix=/usr

make

make install

cd /sources
rm -rf $PACKAGE
