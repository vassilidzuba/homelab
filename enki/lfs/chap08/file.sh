#/bin/bash

echo '****' "Building file"

PACKAGE=file-5.46
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

touch $FLAG
cd /sources
rm -rf $PACKAGE
