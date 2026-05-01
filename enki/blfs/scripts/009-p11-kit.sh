#!/bin/bash


if [ "$SHAREDDIR" = "" ]; then
    echo 'Variable $SHAREDDIR should be defined'
    exit 255
fi

PACKAGE=p11-kit-0.26.2
FLAG=/lfsflags/blfs/$PACKAGE
SOURCE=p11-kit-0.26.2.tar.xz

if [ -f "$FLAG" ]; then
    echo "Package $PACKAGE is already built."
    exit 255
fi

if [ ! -f "/sources/$SOURCE" ]; then
    cp "$SHAREDDIR/$SOURCE" /sources
fi

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $SOURCE
  if [ $? -eq 1 ]; then
      echo "unable to extract archive"
      exit 255
  fi
fi

cd $PACKAGE

sed '20,$ d' -i trust/trust-extract-compat &&

cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF

mkdir p11-build &&
cd    p11-build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D trust_paths=/etc/pki/anchors &&
ninja

if [ "$?" != 0 ]; then
    echo "Build of $PACKAGE failed"
    exit 255
fi

sudo ninja install &&
sudo ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
        /usr/bin/update-ca-certificates &&
sudo ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so

if [ "$?" != 0 ]; then
    echo "Install of $PACKAGE failed"
    exit 255
fi

touch $FLAG
cd /sources
rm -rf $PACKAGE
