# NABU - history

This document describes the installation of node *nabu*.

It is aimed at becoming my main driver, using Arch.

## Context

Arch will be installed in /dev/sda4. There is already a distro in /dev/sda3. The UEFI partition is /dev/sda1. The swap partition is /dev/sda2.

## Base install

(2025-02-06)

The installation manual is at [https://wiki.archlinux.org/title/Installation_guide](https://wiki.archlinux.org/title/Installation_guide). 
What follows is not intended to replace the installation manual, only indicate the essential commands I used during this installation.

I need to select the keyboard map

    loadkeys fr-latin1

ensure clock is synchronized:

    timedatectl

the disk is already partitioned, we only need to format and mount the root partition and enable the swap:

    mkfs.ext4 /dev/sda4
    mount /dev/sda4 /mnt
    mount --mkdir /dev/sda1 /mnt/boot
    swapon /dev/sda2
   
To install the base packages, we use the command:

    pacstrap -K /mnt base linux linux-firmware amd-ucode

warning: amd-ucode is installed in the boot partition, and must be installed only once

To create the fstab:

    genfstab -U /mnt >> /mnt/etc/fstab

To enter the chroot:

    arch-chroot /mnt

Set the timezone:

    ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
    hwclock --systohc

install nano

   pacman -S nano


edit /etc/locale.gen to enable the locales one want, and run:

    locale-gen
    echo LANG=fr_FR.UTF-8 > /etc/locale.conf
    echo KEYMAP=fr-latin1 > /etc/vconsole.conf

install additional packages:

    pacman -S dhcpcd lynx

Do not forget to enable the network:

    echo nabu > /etc/hostname
    systemctl enable systemd-networkd
    systemctl enable dhcpcd

Set the root password:

    passwd

### install boot manager

install required packages:

    pacman -S grub efibootmgr

install grub

    install-grub --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    grub-mkconfig -o /boot/grub/grub.cfg

In my case, I have another distrtibution that i want to add to the grub menu.

    pacman -S os-prober
    mount --mkdir /dev/sda3 /mnt/olddistro

uncomment GRUB_DISABLE_OS_PROBER=false in /etc/default/grub, and run grub-mkconfig again.


We can now reboot in the new install

## Security

We create a new user:

    adduser -m -G users,wheel myuser
    passwd myuser

Allow sudo:

    pacman -S sudo

and uncomment *%wheel ALL (ALL:lALL) ALL* in /etc/sudoers

We can now disable the root password:

   sudo passwd -d root
   sudo passwd -lock root


## Other partitions

We can add other partitions to the fstab. To do that in the installed system, one would install the installation scripts:

    sudo pacman -S arch-install-scripts

then we can mount manually the partitions we are interested in, and generate a fake fstab with

   genfstab / -U > ~/fstab

and finally copy the entries we are interested in to the actual `/etc/fstab`.


## Weyland

Packages:

* nvidia driver: nvidia-open
* session nanager: gdm (?)
* compositor: hyprland

To launch, `hyprland`


## ssh

We install the ssh client.

    sudo pacman -S openssh

We'll test it with a machine names 'odin'. As we don't have a dns (yet), we add odin to the ssh config file ~/.ssh/config :

    Host odin
        Hostname 192.168.0.20
        Port 22
        User vassili

So now we can connect using simply:

    ssh odin

Now we generate a key pair:

    ssh-keygen -t ed25519 -C 'nabu'

with the default file name `~/.ssh/id_ed25519' and a passphrase

we now copy the public key to odin:

    ssh-copy-id -i ~/.ssh/id_ed25519 odin

we can launch and use the ssh agent

    eval "$(ssh-agent)"
    ssh-add -i ~/.ssh/id_ed25519

## Git

We install git:

    sudo pacman -S git

We set the global properties

   git config --global user.email "myself@provider.com"
   git config --global user.name "Vassili Dzuba"


We create a ssh key pair for github:

   ssh-keygen -t ed25510 -C "github"

with the filename ~/.ssh/github_id_ed25519 and a passphrase

We copy the public key to github using a browser.

Then, after adding the githubkey to the ssh agent:
  
    git clone git@github.com:vassilidzuba/homelab.git







