#/bin/bash

echo '****' "Building zstd"

PACKAGE=zstd-1.5.7
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

make prefix=/usr

make check

make prefix=/usr install

rm -v /usr/lib/libzstd.a

touch $FLAG
cd /sources
rm -rf $PACKAGE
