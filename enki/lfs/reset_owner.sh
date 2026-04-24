#!/bin/bash

echo "Update owners"

if [ "$(whoami)" != "root" ]; then
        echo "Script must be run as user: root"
        exit 255
fi

LFS=/mnt/lfs

chown --from lfs -R root:root $LFS/{usr,var,etc,tools}
case $(uname -m) in
  x86_64) chown --from lfs -R root:root $LFS/lib64 ;;
esac
