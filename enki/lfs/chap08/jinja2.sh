#/bin/bash

echo '****' "Building jinja2"

PACKAGE=jinja2-3.1.6
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

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist Jinja2

touch $FLAG
cd /sources
rm -rf $PACKAGE
