#/bin/bash

echo '****' "Building gawk"

PACKAGE=gawk-5.3.2
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

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make

chown -R tester .
su tester -c "PATH=$PATH make check"

rm -f /usr/bin/gawk-5.3.2
make install

touch $FLAG
cd /sources
rm -rf $PACKAGE
