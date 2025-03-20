## Assur

The initial state is a pre-installed Ubuntu desktop.

user : gmk (id=1000) group gmk (id=1000)

While waiting for the installation of an ubuntu server,minimalchanges will be done:

* change hostname to *assur*
* create zfs pool with a single disk

    sudo zpool create nas1 nvme0n1

* add host to the domain (with bin9 config in odin)
* add samba share (*nas1*)   
* add package openssh-server; enable service ssh


