#/bin/bash

echo '****' "Building iproute2"

PACKAGE=iproute2-6.18.0
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

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

./configure --prefix=/usr

make NETNS_RUN_DIR=/run/netns

make SBINDIR=/usr/sbin install

install -vDm644 COPYING README* -t /usr/share/doc/iproute2-6.18.0

touch $FLAG
cd /sources
rm -rf $PACKAGE
