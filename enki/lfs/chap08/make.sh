#/bin/bash

echo '****' "Building make"

PACKAGE=make-4.4.1
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

./configure --prefix=/usr

make

chown -R tester .
su tester -c "PATH=$PATH make check"

make install


touch $FLAG
cd /sources
rm -rf $PACKAGE
