#/bin/bash

echo '****' "Building gettext"

PACKAGE=gettext-1.0
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

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-1.0

make

make check

make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

touch $FLAG
cd /sources
rm -rf $PACKAGE
