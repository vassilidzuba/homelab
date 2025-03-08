# Odin: history

## context

This machine is an old PC running Linux Mint.

## Podman

We first install podman:

    apt-get install podman

The installed version is *4.9.3*.


### Making podman rootless

Second step will be to make podman rootless, as described in [https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md).

Note that we don't use the most recent version of podman, so wwe use `slirp4netns` and not `pasta`. The documentation indicates to install `shadow-utils` or `newuid`, but on mint the package is `passwd`.

We will create a `podman` user, without sudo priviledges:

    sudo useradd -s /bin/bash -m podm
    sudo passwd podman

## DNS

We will install a DNS server in a podman container. We will use *bind9* from the Ubuntu reposirotu:

    podman pull docker.io/ubuntu/bind9:9.18-22.04_beta

Warning: port 53 is already used on mint by service *systemd-resolved*. It is hoverver possible to start this service after *bind9*
because *systemd-resolved* does not open port 53 if it is already open by somebody else.

The DNS will contains the data for our internal domain *manul.lan*.

Bind will need two configuration files.

The main configuration file will be in `/usr/local/etc/bind/nanmed.conf`. A copy is available here : [config/bind9/named.conf](config/bind9/named.conf).

The zone configuration file will be in `/usr/local/etc/bind/manul-lan.zone`. A copy is availabe in [config/bind9/manul-lan.zone](config/bind9/manul-lan.zone).

There is also need to create directories `/var/cache/bind`, `var/lib/bind` and `/var/log/bind`. These directories will belong to
an user with uid 101, as it is the case of the *bind* user in the container.

The container can be run with the command:

    podman run \
       -d \
       --replace \
       --userns=keep-id \
       --name bind9-container \
       -e TZ=Europe/Paris \
       -p 53:53/tcp -p 53:53/udp \
       -v /usr/local/etc/bind/named.conf:/etc/bind/named.conf \
       -v /usr/local/etc/bind/manul-lan.zone:/etc/bind/manul-lan.zone \
       -v /var/cache/bind:/var/cache/bind \
       -v /var/lib/bind:/var/lib/bind \
       -v /var/log/bind:/var/log \
       docker.io/ubuntu/bind9:9.18-22.04_beta  $1

That command must be run as root, to be able to open port 54.

To manage this service with systemd, one creates a file `/etc/containers/systemd/bind9.container`.
A copy is available in [config/bind9/bind9.container](config/bind9/bind9.container).



## Nginx

First experiment will be to run nginx under podman.

We install nginx with podman:

    podman pull docker.io/library/nginx:latest

We can run it with the command

     podman run -d -p 8080:80 nginx

### Building the site

We want to make a website with the javadoc of our projects.

To do so, we will need java:

    sudo apt install openjdk-21-jdk-headless

The site will be built by a script `launch-nginx.sh`.

The script will resile in ~podman/nginx.

* expects that there is a subdirectory `javadoc` with the javadoc archives produced my maven
* will create a subdirectory `html` which will contain the uncompressed javadoc and an `index.html` file.

The script is available at [scripts/launch-nginx.sh](scripts/launch-nginx.sh)



### Managing nginx with systemd

We use here the user `podman`. The files in /home/vassili/nginx/html have been copied to /home/podman/html.

We need to create a file `~/.config/containers/systemd/nginx.container`. A copy is available in [scripts/nginx.container](scripts/nginx.container).

To run nginx:

    systemctl --user daemon-reload
    systemctl --user start nginx

note: the magic is performed by a systemd generator installed by podman, that understands the extension *.container*. The command `daemon-reload` 
is necessary if changes are made to the .container file.

### PostgreSQL

We will install PostgresSQL with podman, to be used later by gitea.

    podman pull docker.io/library/postgres:latest


### Gitea

We will install Gitae, a git server.

    sudo podman network create gitea-net
    


