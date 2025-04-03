# Odin: history

## context

This machine is an old PC running Linux Mint. Its IP address is 192.168.0.20.

The ports exposed by the various services are:

* 53! bind9
* 2222: gitea (ssh)
* 3000: gitea (http)
* 5000: registry
* 5432: postgres
* 8080: nginx (http)
* 8081: nexus (http)
* 8483: nginx (https)
* 9000: sonarqube (http)

## Startup

With the current configuration, the disks are not mounted automatically.
They can be mounted using the desktop environment UI, or in console mode using `udisksctl`, for instance:

    udisksctl -b /dev/sda1

Note: that 

## Podman

We first install podman:

    apt-get install podman

The installed version is *4.9.3*.


### Making podman rootless

Second step will be to make podman rootless, as described in [https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md).

Note that we don't use the most recent version of podman, so we use `slirp4netns` and not `pasta`. The documentation indicates to install `shadow-utils` or `newuid`, but on mint the package is `passwd`.

We will create a `podman` user, without sudo priviledges:

    sudo useradd -s /bin/bash -m podm
    sudo passwd podman
    
We create a ssh key pair for podman:

    ssh-keygen -t ed25519 -C 'podman'

### Using podman with systemd

Podman installs a systemd generator that understands the extension *.container*. The command `daemon-reload` 
is necessary if changes are made to the .container file.

When running rootless, the .container file should be put in directory `~/.config/containers/systemd`.
When running as root, it must be put in directory `/etc/containers/systemd`.

Foe a rootless server, e.g. nginx, the commands are:

    systemctl --user daemon-reload
    systemctl --user start nginx

For a  root server, e.g. bind9, the commands are:

    systemctl --user daemon-reload
    systemctl --user start bind9

### podman-system-service

This service makes the REST API available. To make that service available for the current user for rootless containers, *podman*, execute:

    systemctl --user start podman.socket
    loginctl enable-linger podman

The sockat will be :

    $XDG_RUNTIME_DIR/podman/podman.sock

One can now run for instance:

    curl --unix-socket $XDG_RUNTIME_DIR/podman/podman.sock 'http://d/v5.0.0/libpod/images/json'

### Build image

To build an image for a java program, we can use a Dockerfile (or Containerfile), the simplest being:

    FROM docker.io/library/amazoncorretto:21-alpine
    COPY simple-0.0.1-SNAPSHOT.jar /
    CMD java -jar simple-0.0.1-SNAPSHOT.jar

We build the image with:

    podman build -f Dockerfile

Note that we get the image id, that can be user later.Let's assume it is 62d2b73d11fd.

Tu run the image:

    podman run -ti 62d2b73d11fd

To delete the image (that requires that no container use that image any more):

    podman rmi 62d2b73d11fd


### running maven in Podman

We first need to choose our maven image:

    podman pull docker.io/library/maven:3.9.9-amazoncorretto-21-alpine

To build the project *simple*, we can use:

    podman run -it --rm --name simple -v "$(pwd)/simple":/usr/src/simple -w /usr/src/simple maven:3.9.9-amazoncorretto-21-alpine mvn clean install

Of course, this will reload all the dependencies at each run, which is not good. We will use the maven repo of the user so that we can reuse downloaded artifacts. We have then:

    podman run -it --rm --name simple -v "$HOME/.m2:/root/.m2" -v "$(pwd)/simple":/usr/src/simple -w /usr/src/simple maven:3.9.9-amazoncorretto-21-alpine mvn clean install

The installed jar is now in:

    ~/.m2/repository/vassilidzuba/simple/simple/0.0.1-SNAPSHOT/simple-0.0.1-SNAPSHOT.jar

## DNS

We will install a DNS server in a podman container. We will use *bind9* from the Ubuntu reposirotu:

    podman pull docker.io/ubuntu/bind9:9.18-22.04_beta

Warning: port 53 is already used on mint by service *systemd-resolved*. It is however possible to start this service after *bind9*
because *systemd-resolved* does not open port 53 if it is already open by somebody else.

The nameserver address provided by the DHCP is 192.168.0.254 for ipv4 and fd0f:ee:b0::1 for ipv6.

we will replace /etc/resolv.conf by a static file, while it is currently a symbolic link to /run/systemd/resolve/resolv.conf.
The new value will be:

    domain manul.lan
    nameserver 192.168.0.20
    nameserver fd0f:ee:b0::1
    search .

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

That command must be run as root, to be able to open port 53.

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

The script will reside in ~podman/nginx.

* expects that there is a subdirectory `javadoc` with the javadoc archives produced my maven
* will create a subdirectory `html` which will contain the uncompressed javadoc and an `index.html` file.

The script is available at [scripts/launch-nginx.sh](scripts/launch-nginx.sh)

Note: when replacing the files in the shared html directory from outside the container,they are not visible
from inside the container;one has to restart it.

### Managing nginx with systemd

We use here the user `podman`.

We need to create a file `~/.config/containers/systemd/nginx.container`. A copy is available in [scripts/nginx.container](scripts/nginx.container).

To run nginx:

    systemctl --user daemon-reload
    systemctl --user start nginx

## PostgreSQL

We will install PostgresSQL with podman, to be used later by gitea.

    podman pull docker.io/library/postgres:latest

We create a directory `/home/podman/postgresql/data`.

We can run the container with:

    podman run -d  --name pg -p 5432:5432 -v /home/podman/postgres/data:/var/lib/postgresql/data   -e 'POSTGRES_PASSWORD=*****' postgres:latest

We can also run it using systemd. We need to create a file `~/.config/containers/systemd/postgres.container`. A copy is available in [scripts/postgres.container](scripts/postgres.container), but for the password.

Now, to run postgres:

    systemctl --user daemon-reload
    systemctl --user start postgres
    loginctl enable-linger podman

## Gitea

We will install Gitea, a git server, in a rootless container.

There is an image available:

    podman pull docker.io/gitea/gitea:latest-rootless

### Database preparation

We need to create gitea user and database in postgres: We assume that the container name of postgres is *pg*.

    podman exec -it pg bash

in the container, one launches *psql* as root (no password required):

    su -c "psql" - postgres
    
in psql:

    CREATE ROLE gitea WITH LOGIN PASSWORD 'gitea';
    CREATE DATABASE giteadb WITH OWNER gitea TEMPLATE template0 ENCODING UTF8 LC_COLLATE 'en_US.UTF-8' LC_CTYPE 'en_US.UTF-8';
    

One need to add two lines to pg_hba.conf!

    local    giteadb    gitea    scram-sha-256
    host    giteadb    gitea    192.0.2.10/32    scram-sha-256t

Within the container, this file is in directory `/var/lib/postgresql/data`. It can be accessed from outside the container at `/home/podman/postgres/data`.

Next one need to restart postgres.

### Running Gitea

One can run gitea with a docker compose file:

    version: "2"
    
    services:
      server:
        image: docker.gitea.com/gitea:1.23.5-rootless
        restart: always
        user: 1001
        volumes:
          - ./data:/var/lib/gitea
          - ./config:/etc/gitea
          - /etc/timezone:/etc/timezone:ro
          - /etc/localtime:/etc/localtime:ro
        ports:
          - "3000:3000"
          - "2222:2222"


### Running gitea with systemd

The container definition is `~podman/.config/containers/systems/gitea.containers`. There is acopy in [scripts/gitea.container](scripts/gitea.container).

### Accessing gitea

The web interface can be accessed at `http://odin:3000`.

## Image registry

We will install the Docker Image registry:

    podman pull docker.io/library/registry:latest

To run it for test purpose (without permanent storage):

    docker run -d -p 5000:5000 --restart always --name registry docker.io/library/registry:latest
    
To pull an image of the simple java app to the repository:

    podman tag 62d2b73d11fd 192.168.0.20:5000/simple
    podman push --tls-verify=false  192.168.0.20:5000/simple

As configured, the registry doesn't support TLS. We need to use the option *--tls-verify=false* for both *podman pull* and *podman push*.


### Deploying the registry with systemd

The container file should be in `~podman/.config/containers/systemd/registry.container`. A copy is available in
[scripts/registry.container](scripts/registry.container).

To run it:

    systemctl --user daemon-reload
    systemctl --user start registry

### useful commands

The registry has a REAS API available at [https://distribution.github.io/distribution/spec/api/](https://distribution.github.io/distribution/spec/api/).

To obtain the list of repositories:

    curl http://odin:5000/v2/_catalog

to obtain the tags of a given repository:

    curl http://odin:5000/v2/<repo>/tags/list



## SonarQube

we can run a test version of SonarQube with the command:

    podman run \
        -d \
        --name sonarqube-custom \
        --stop-timeout 3600 \
        -v /home/podman/sonarqube/data:/opt/sonarqube/data \
        -v /home/podman/sonarqube/logs:/opt/sonarqube/logs \
        -v /home/podman/sonarqube/extensions:/opt/sonarqube/extensions \
        -p 9000:9000 \
        docker.io/library/sonarqube:community

We need to obtain a authentication token from the SonarQube instance. The default user/password are admin/admin.

To analyse the modules, one need to add the plugin in the root POM:

    <plugin>
        <groupId>org.sonarsource.scanner.maven</groupId>
        <artifactId>sonar-maven-plugin</artifactId>
        <version>5.0.0.4389</version>
    </plugin>

We can analyse the project *yacic* with the command:

    mvn -Dsonar.host.url=http://192.168.0.20:9000 -Dsonar.token=*****  sonar:sonar

Note: for the time being, we stay with the H2 database.

We will now run it under systemd. See [scripts/sonarqube.container](scripts/sonarqube.container) for the container description file, to be stored in `~/.config/containers/systemd/sonarqube.container`.

and:

    systemctl --user daemon-reload
    systemctl --user start sonarqube
    
### Using sonar from maven in container

As the token should be ketp confidential, we first store the token in a podman secret, `sonar-token`.

The token will be made available in the container by the podman option `--secret sonar-token,type=env,target=token`. 
That means that the environment variable `$token` will be available in the container but not when running the podman command. I didn't find a simpler way that to create another image
`192.168.0.20:5000/maven-sonar:java21` using the Dockerfile:

    from docker.io/library/maven:3.9.9-amazoncorretto-21-alpine
    
    CMD /usr/bin/mvn -Dsonar.token=$token sonar:sonar


## Nexus3

The image is :

    podman pull docker.io/sonatype/nexus3:latest

We will use a persistent volume

    podman volume create nexus-data
    podman run -d -p 8081:8081 -v nexus-data:/sonatype-work  --name nexus sonatype/nexus3

To get the admin password, connect to the container:

     podman exec -it nexus bash

Tu use nexus from maven, one must specify a `settings.xml` file in `~/.m2.settings.xml`. A copy is available in
[config/nexus/settings.xml](config/nexus/settings.xml), with the password hidden.

To deploy using systemd, see [scripts/nexus.container](scripts/nexus.container). The commands are:

    systemctl --user daemon-reload
    systemctl --user start nexus


## Mount samba share from Assur

We mount it using systemd (like with *Nabu*). So, we need to :

* put [mnt-nas1.mount](config/samba/mnt-nas1.mount) in `/etc/systemd/system`
* put credential file [nas1](config/samba/nas1) in `/etc/samba/credentials/nas1` (in the shown file the passsword has been masked)
* enable end start service

    sudo systemctl daemon-reload
    sudo systemctl start mnt-nas1.mount
    sudo systemctl enable mnt-nas1.mount

Note that the `credentials` should have mode 777, and the credential file mode 660.

On the server Assur, user *gmk* has uid 1000. As we specifgy uid 1000 in the mount options, the mounted directory will be seen as belonging to user *vassili*, that has uid 1000on Odin.
