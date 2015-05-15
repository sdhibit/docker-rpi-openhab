# openHAB image on Raspberry Pi

Docker image of [openHAB](http://www.openhab.org/) 1.6.2 using the [rpi-java](https://github.com/sdhibit/docker-rpi-java) base image.

## Features

* Raspbian Jessie based 
* [Runit](http://smarden.org/runit/) process management
* [Touch UI](http://m-design.bg/greent/) and [HABmin](https://github.com/cdjackson/HABmin) pre-installed
* All official addons pre-provided. Selective enabling of addons on boot
* Demo Configuration starts when no configuration is found


# Building Image

```shell
$ git clone https://github.com/sdhibit/docker-rpi-openhab.git
$ cd docker-rpi-openhab
$ sudo docker build -t docker-rpi-openhab .
```

# Running Container

By default, this image will run the demo configuration if the openhab.cfg file is not found in /etc/openhab. The demo sitemap can be viewed at the following url: `http://{host-ip}:8080/openhab.app?sitemap=demo`

```shell
$ sudo docker run \
    --publish=8080:8080 \
    --publish=8443:8443 \
    --publish=5555:5555 \
    --detach=true \
    sdhibit/rpi-openhab
```

## Basic Demo with Data Container

A separate [data only volume](https://docs.docker.com/userguide/dockervolumes/) can be started to preserve state from the application container. The following will also start a demo sitemap which can be viewed at: `http://{host-ip}:8080/openhab.app?sitemap=demo` 
A docker compose file is included in the repository that will start this example. [Docker Compose](https://docs.docker.com/compose/yml/) for the Raspberry Pi can be installed using [Hypriot's release](https://github.com/hypriot/compose)

Start data container:

```shell
$ sudo docker run \
	--name openhabdata \
    sdhibit/rpi-openhab /bin/true
```

Start openhab container

```shell
$ sudo docker run \
	--name openhab \
	--volumes-from openhabdata \
 	--publish=8080:8080 \
    --publish=8443:8443 \
    --publish=5555:5555 \
    --detach=true \
    sdhibit/rpi-openhab
```

## Basic Demo with host config volume

When mounting volumes from the host, all files within that volume are overwritten with whatever is in the host's directory. Since openHAB expects a certain folder stucture in the configuration directory `/etc/openhab`, this image will create the required structure on boot even when mapping an empty host volume. The host directories must have the correct permissions set to allow the openhab user (currently uid `300` gid `300`). 

```shell
$ sudo docker run \
	--name openhab \
	--volume {host config dir}:/etc/openhab \
	--volume {host log dir}:/var/log/openhab \
	--publish=8080:8080 \
    --publish=8443:8443 \
    --publish=5555:5555 \
    --detach=true \
    sdhibit/rpi-openhab
```

# Configuration

Todo: Put configuration info here
 - Addons
 - GreenT
 - HABmin

# Known Issues

### Java getHostName() errors with host networking enabled

Many openHAB addons (Squeezebox, Sonos, etc.) use UPnP to discover services on your local LAN. In order for this image to utilize these addons, `--net="host"` must be added to the docker run command. When [host networking](https://docs.docker.com/articles/networking/) is enabled in docker, among other things, the /etc/hosts file is copied from the host to the container and the container adopts the hostname of the host. Many times, the hostname of the host is not present in the /etc/hosts file. 

Certain features in openHAB call the `InetAddress.getLocalHost().getHostName()` function which will fail if the current hostname is not in the `/etc/hosts` file. This error does not occur when `--net="host"` is not necessary.

#### Fix
On docker host:
```shell
 $ echo "127.0.0.1 $(hostname)" >> /etc/hosts
```

# Thanks



# Todo

* Custom SSL configuration
* Allow addition of non-official addons from config volume
* USB device mapping
