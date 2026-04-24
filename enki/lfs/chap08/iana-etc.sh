#/bin/bash

echo '****' "Copying iana-etc"


PACKAGE=iana-etc-20260202
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

cp -v services protocols /etc

touch $FLAGcd /sources
rm -rf $PACKAGE
