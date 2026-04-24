#/bin/bash

echo '****' "Building zlib"

PACKAGE=zlib-1.3.2
FLAG=/lfsflags/chap08/$PACKAGE

if [ -f $FLAG ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi


cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvzf $PACKAGE.tar.gz
fi

cd $PACKAGE

./configure --prefix=/usr

make

make check

make install

rm -fv /usr/lib/libz.a

touch $FLAG
cd /sources
rm -rf $PACKAGE
