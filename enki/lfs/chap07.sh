#/bin/bash

echo "Building chapter 7"

<if [ "$(whoami)" != "root" ]; then
        echo "Script must be run as user: lfs"
        exit 255
fi

mkdir -p -v ~/logs

./chap07/prepare_vfs.sh | tee ~/logs/chap07_prepare_vfs.log
