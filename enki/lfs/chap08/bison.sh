#/bin/bash

echo '****' "Building bison"

PACKAGE=bison-3.8.2
FLAG=/lfsflags/chap08/$PACKAGE

if [ -f $FLAG ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
  if [ $? -eq 1 ]; then
      echo "unable to extract archive"
      exit 255
  fi
fi

cd $PACKAGE

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2

make

make check

make install

touch $FLAG
cd /sources
rm -rf $PACKAGE
