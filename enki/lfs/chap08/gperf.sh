#/bin/bash

echo '****' "Building gperf"

PACKAGE=gperf-3.3
FLAG=/lfsflags/chap08/$PACKAGE

if [ -f $FLAG ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvzf $PACKAGE.tar.gz
  if [ $? -ne 0 ]; then
      echo "unable to extract archive"
      exit 255
  fi
fi

cd $PACKAGE

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.3

make

make check

make install

touch $FLAG
cd /sources
rm -rf $PACKAGE
