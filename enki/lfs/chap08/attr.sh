#/bin/bash

echo '****' "Building attr"

PACKAGE=attr-2.5.2
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

./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.5.2

make

make check

if [ $? -eq 1 ]; then
    echo "check failed"
    exit 255
fi


make install

touch $FLAG
cd /sources
rm -rf $PACKAGE
