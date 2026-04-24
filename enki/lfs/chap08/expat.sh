#/bin/bash

echo '****' "Building expat"

PACKAGE=expat-2.7.4
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

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.7.4

make

make check

make install

install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.7.4

touch $FLAG
cd /sources
rm -rf $PACKAGE
