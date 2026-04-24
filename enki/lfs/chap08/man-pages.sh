#/bin/bash

echo '****' "Compiling man-pages"

PACKAGE=man-pages-6.17
FLAG=/lfsflags/chap08/$PACKAGE

if [ -f $FLAG ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

rm -v man3/crypt*

make -R GIT=false prefix=/usr install

touch $FLAG
cd /sources
rm -rf $PACKAGE
