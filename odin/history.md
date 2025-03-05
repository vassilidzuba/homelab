# Odin: history

## context

This machine is an old PC running Linux Mint.

## Podman

We first install podman:

    apt-get install podman

The installed version is *4.9.3*.

## Nginx

We install nginx with podman:

    podman pull docker.io/library/nginx:latest

We can run it with the command

     podman run -d -p 8080:80 nginx

### Building the site

We want to make a website with the javadoc of our projects.

To do so, we will need java:

    sudo apt install openjdk-21-jdk-headless

The site will be built and nginx launched by a script `launch-nginx.sh`.

Th script

* expects that there is a subdirectory `javadoc` with the javadoc archives produced my maven
* will create a subdirectory `html` which will contain the uncompressed javadoc and an `index.html` file.

The script is available at [scripts/launch-nginx.sh](scripts/launch-nginx.sh)

In this script, the command to launbch nginx is:

    podman run -d -p 8080:80 -v $curdir/html:/usr/share/nginx/html:Z nginx

with `-v`, we map the site content, out of the container, to the directory where nginx expects it.


