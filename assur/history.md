## Assur

The initial state is a pre-installed Ubuntu desktop.

user : gmk (id=1000) group gmk (id=1000)

While waiting for the installation of an ubuntu server, minimal changes will be done:

* change hostname to *assur*
* create raidz zfs pool with four disks

    sudo zpool create nas1 raidz nvme0n1 nvme1n1 nvme2n1 nvme3n1

* deactivate atime

    sudo zfs set atime=off nas1

* add host to the domain (with bin9 config in odin)
* add user podman (uid 1001)
* add samba share (*homelab* on directory */nas1/homelab*); add samba user (gmk)
* add samba share (*archive* on directory */nas1/archive*);
* add samba share (*yacic* on directory */nas1/yacic*); add samba user (podman)
* add package openssh-server; enable service ssh

