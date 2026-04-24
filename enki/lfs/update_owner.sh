#!/bin/bash

echo "Update owners"

if [ "$(whoami)" != "root" ]; then
        echo "Script must be run as user: root"
        exit 255
fi

LFS=/mnt/lfs

chown -v lfs $LFS/{usr{,/*},var,etc,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac
