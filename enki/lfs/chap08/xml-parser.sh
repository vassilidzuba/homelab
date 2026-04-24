#/bin/bash

echo '****' "Building XML::Parser"

PACKAGE=XML-Parser-2.47
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

perl Makefile.PL

make

make test

make install

touch $FLAG
cd /sources
rm -rf $PACKAGE
