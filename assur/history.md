# Assur

## OS installation

Installation of Ubuntu Server 24.04.02 LTS, in standard configuration (not minimized).
Allowed installation, of OpenSSH server.

host name: `assur`
user is `vassili`

System upgrade

   sudo apt update
   sudo apt upgrade

Note: after the first reboot, the network was nor available.
It seems that was an error in the file `/etc/netplan/50-cloud-init.yaml`, where the interface name was incorrect (`enp5s0` instead of `enp3s0`).
After correcting and executing `sudo netpplan apply`, the network was available.

Ubuntu server uses by default `systemd-networkd`, but it cound be possible to configure it to use `NetworkManager`.

It is also necessary to change the addresses of the DNS, to use the DNS on `odin`. That can be done also by *netplan*. The configuration file `/etc/netplan/50-cloud-init.yaml`
will contain:

```config
network:
  version: 2
  ethernets:
    enp3s0:
      nameservers:
        addresses: [192.168.0.20, fd0f:ee:b0::1]
      dhcp4: true
      dhcp6: true
```

Note that the IPv6 address in this configuration file is the address of the freebox.

## DNS

The machine should be added to the DNS on Odin, as `assur.manul.odin`.

## Additional user		

	sudo useradd podman --home /home/podman/ --create-home --shell /bin/bash
	sudo useradd 

## SSH

From *odin*, where the ssh keys are:

as user `vassili`:
	ssh-copy-id -i ~vassili/.ssh/id_ed25519.pub vassili@assur.manul.lan


as user `podman`:
	ssh-copy-id -i ~podman/.ssh/id_ed25519.pub podman@assur.manul.lan

SSH wasn't enables by default:

    sudo systemctl enable ssh

## Add various packages

    sudo apt smartmontools
    sudo apt install zfsutils-linux
    sudo apt samba
    
## Add ZFS pool

    sudo zpool create nas1 nvme0n1
    sudo zfs set atime=off nas1

There will be three directories shared by samble:

* `/nas1/yacic` as the shared work area for yacic, belonging to `podman`
* `/nas1/homelabc` containing files related to the homelab, belonging to `vassili`
* `/nas1/archivage` containing miscellanous data, belonging to `vassili`

    sudo mkdir /nas1/yacic
    sudo mkdir /nas1/homelab
    sudo mkdir /nas1/archive
    
    sudo chown -R vassili:vassili /mnt/homelab
    sudo chown -R vassili:vassili /mnt/archive
    sudo chown -R podman:podman /mnt/yacic

## Add Samba

Add the samba users:

    sudo smbpasswd -a vassili
    sudo smbpasswd -a podman

Add to the file `/etc/samba/smb.conf`:

```config
[homelab]
    comment = share for homelab
    path = /nas1/homelab
    read only = no
    force user = "vassili"
    force group = "vassili"
    browsable = yes

[yacic]
    comment shares for Yacic
    path = /nas1/yacic
    read only = no
    force user = "podman"
    force group = "podman"
    browsable = yes

[archive]
    comment shares for various archives
    path = /nas1/archive
    read only = no
    force user = "vassili"
    force group = "vassili"
    browsable = yes
```
