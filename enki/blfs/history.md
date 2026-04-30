# Enki installation - BLFS

This is based on  [https://www.linuxfromscratch.org/blfs/](BLFS book, version 13.0).

We will assume the LFS installation, is run under QUEMU.

## Sharing files

We want to be able to copy files from the host to the LFS installations. 
To do so, we will use [virtiofsd](https://wiki.archlinux.org/title/QEMU#Host_file_sharing_with_virtiofsd).

We fist need to install virtiofsd:

    sudo pacpam -S virtiofsd

We run the virtiofs daemon:

    sudo mkdir /tmp/vm-share
    sudo /usr/lib/virtiofsd --socket-path /tmp/vm-share.sock --socket-group kvm --shared-dir /tmp/vm-share

We ensure that /mnt/lfs is not mounted on the host

    sudo umount /mnt/lfs

We can then run the guest (LFS):

    sudo qemu-system-x86_64 \
        -kernel /boot/vmlinuz-6.18.10-lfs-13.0-systemd \
        -drive file=/dev/sda,format=raw \
        -append "root=/dev/sda3 console=ttyS0" \
        -nographic \
        -m 4G \
        -object memory-backend-memfd,id=mem,size=4G,share=on \
        -numa node,memdev=mem \
        -chardev socket,id=char0,path=/tmp/vm-share.sock \
        -device vhost-user-fs-pci,chardev=char0,tag=myfs

on the host, we give the access right to our normal user:

    chown xxx:yyy /tmp/vm-share

In the guest, one mount the shared directory:

    mount -t virtiofs myfs /mnt/vm-share

## Running scripts

The scripts are in the directory `./scripts`. To use them one need to:

* on the host, copy then to the shared volume using `./copy-to-share.sh`
* on the guest, run them as `/mnt/vm-share/...` 
* on the guest export the variable `SHAREDDIR` with the value `/mnt/vm-share`

## Add an user

One can add an user by running the script [01-create-user.sh](./scripts/01-create-user.sh)
