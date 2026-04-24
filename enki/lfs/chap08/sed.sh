#/bin/bash

echo '****' "Building sed"

PACKAGE=sed-4.9
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

./configure --prefix=/usr

make
make html

chown -R tester .
su tester -c "PATH=$PATH make check"

make install
install -d -m755           /usr/share/doc/sed-4.9
install -m644 doc/sed.html /usr/share/doc/sed-4.9

touch $FLAG
cd /sources
rm -rf $PACKAGE
