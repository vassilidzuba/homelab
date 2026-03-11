# Ptah

Ptah is running debian 13

## Initial configuration

- change server name to *ptah*

    hostname ptah

- create user (we will use *theuser* as the name of the user in this documentation)

    adduser theuser

- add user to *sudo* group

    usermod theuser -G sudo

- copy xterm-kitty to ptah (should be in */usr/share/terminfo/x*)

## Network configuration

- ensure we have an ipv5 address

- buy a domain, e.g. from cloudflare. We will call it *mydomain*.

- define the DNS records (AAAA for ipv6)

- declare the domain using command `domainname`


## ssh configuration

- copy ssh certificate to ptah using `ssh-copy-id`
- set *PermitRootLogin* to *no* in  `/etc/ssh/sshd_config`
- to see logs: `journalctl -u ssh`


## Misc installs

- install htop
- install dnsutils

# NGINX configuration

- install nginx
  
    apt install nginx

- copy source files to `/usr/share/nginx/html

- install certbot ([http://certbot.eff.org](http://certbot.eff.org)) to get certificate from
  Let's encrypt.

- generate the certificates using certbot

    sudo certbot certonly --nginx

- update nginx configuration

    - run nginx as user `www-data`
    - redirect port 80 to port 443
    - listen to ipv6 (`listen [::]:80`)
    - add a server declaration for https, using the previously obtained certificates
