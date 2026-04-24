#/bin/bash

echo '****' "Building less"

PACKAGE=less-892
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

./configure --prefix=/usr --sysconfdir=/etc

make

make clean

make install

touch $FLAG
cd /sources
rm -rf $PACKAGE
