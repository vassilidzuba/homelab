# Enki installation - BLFS

This is based on  [https://www.linuxfromscratch.org/blfs/](BLFS book, version 13.0).

We will assume the LFS installation, is run under QUEMU.

## Sharing files

We want to be able to copy files from the host to the LFS installations. 
To do so, we will use [virtiofsd](https://wiki.archlinux.org/title/QEMU#Host_file_sharing_with_virtiofsd).

We first need to install virtiofsd:

    sudo pacman -S virtiofsd

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
        -cpu host \
        -enable-kvm \mkdir .lfsflags  
        -device vhost-user-fs-pci,chardev=char0,tag=myfs

on the host, we give the access right to our normal user:

    chown xxx:yyy /tmp/vm-share

In the guest, one mount the shared directory:

    mount -t virtiofs myfs /mnt/vm-share

## Running scripts

The scripts are in the directory `./scripts`. To use them one need to firstly:

* on the host, copy the to the shared volume using `./copy-to-share.sh`
* on the guest, run them as `/mnt/vm-share/...` 

When the dowload programs ara available (`wget` ou `curl`) onre can change the 
workflox/

* on the host, copy the scripts the shared volume using `./copy-to-share.sh`
* on the guest, run them as `/mnt/vm-share/...` 

The scripts use two utility scripts:

* [_params.sh](./scripts/_params.sh)
* [_utilities.sh](./scripts/_utilities.sh)

The script `_params.sh` contains the definition of the essential directories:

* SHAREDDIR : dirtectory shared betwwen the hosty andf the guest, seen from the guest
* SRCDIR: directory of the sources, where the build is performed
* FLAGDIR: directory where are stored the flags indicating a build has been perfoemd


## Downloading packages

At the beginning, the guest (LFS) isn't able to dowload packages yet, 
so we download them on the host with the script [download.sh](./download.sh).

## Add an user

One can add an user by running the script [001-create-user.sh](./scripts/001-create-user.sh)

## Build *sudo*

To be able to effectively use the new user, one need to build `sudo`.

The build script is [002-sudo.sh](./scripts/002-sudo.sh).

One needs to add the user to the group `wheel`:

    usermod -a -G wheel username

where *username* si replacved by the actual user name.

After checking that sudo actually works, one can disable
the root password:

     sudo passwd -d root
     sudo passwd --lock root

## Build some other packages

As it's fun to have *fastfetch* (in extra), we fist need to build
some packages befotre being able to build *fastfetch*:

* [003-cmake.sh](scripts/003-cmake.sh)

We need an editor (for those that don't like `vim`):

* [004-nano.sh](scripts/004-nano.sh)

We need program to download files from the internet (`wget` and `curl`):

* [005-libunistring.sh](scripts/005-libunistring.sh)
* [006-libidn2.sh](scripts/006-libidn2.sh)
* [007-libpsl.sh](scripts/007-libpsl.sh)
* [008-libtasn1.sh](scripts/008-libtasn1.sh)
* [009-p11-kit.sh](scripts/009-p11-kit.sh)
* [010-nspr.sh](scripts/010-nspr.sh)
* [011-nss.sh](scripts/011-nss.sh)
* [012-make-ca.sh](scripts/012-make-ca.sh)
* [013-nettle.sh](scripts/013-nettle.sh)
* [014-gnutls.sh](scripts/014-gnutls.sh)
* [015-wget.sh](scripts/015-wget.sh)
* [016-curl.sh](scripts/016-curl.sh)

note: many wget tests failed, for unknown reason. The program seems to work however.

We will also need `git`:

* [017-git.sh](scripts/017-git.sh)

Next we install sshd:

* [018-openssh.sh](scripts/018-openssh.sh)

Note: this script does not install the systemd unit file.
When running under quemu, one must specify in the quemu
launch script:

    sudo qemu-system-x86_64 \
        . . .
        -device e1000,netdev=net0 \
        -netdev user,id=net0,hostfwd=tcp::5555-:22

and the guest can then be accessed from the host by:

    ssh -p 5555 localhost

We will now build some libraries usefull for building `fastfetch` (in *extra*):

* [019-nasm-turbo.sh](scripts/019-nasm-turbo.sh)
* [020-libjpeg-turbo.sh](scripts/020-libjpeg-turbo.sh)
* [021-libpng.sh](scripts/021-libpng.sh)
* [022-pixman.sh](scripts/022-pixman.sh)
* [023-which.sh](scripts/023-which.sh)
* [024-icu.sh](scripts/024-icu.sh)
* [025-libxml2.sh](scripts/025-libxml2.sh)
* [026-libxslt.sh](scripts/026-libxslt.sh)
* [027-brotli.sh](scripts/027-brotli.sh)
* [028-freetype.sh](scripts/028-freetype.sh)
* [029-json-c.sh](scripts/029-json-c.sh)
* 
* [20-librsvg.sh](scripts/019-librsvg.sh)
* [20-librsvg.sh](scripts/019-librsvg.sh)
