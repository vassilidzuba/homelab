#/bin/bash

echo '****' "Compiling bison"

PACKAGE=bison-3.8.2

if [ -f /usr/bin/bison ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2
make

make install

cd /sources
rm -rf $PACKAGE
