#/bin/bash

echo '****' "Building libtool"

PACKAGE=libtool-2.5.4
FLAG=/lfsflags/chap08/$PACKAGE

if [ -f $FLAG ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
  if [ $? -ne 0 ]; then
      echo "unable to extract archive"
      exit 255
  fi
fi

cd $PACKAGE

./configure --prefix=/usr

make

make check

make install

rm -fv /usr/lib/libltdl.a

touch $FLAG
cd /sources
rm -rf $PACKAGE
