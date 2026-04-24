#/bin/bash

echo '****' "Building groff"

PACKAGE=groff-1.23.0
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

PAGE=A4 ./configure --prefix=/usr

make

make check

make install

touch $FLAG
cd /sources
rm -rf $PACKAGE
