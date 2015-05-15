# openHAB container on Raspberry Pi

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

# Running container

## Basic demo container 

```shell
$ sudo docker run \
    --publish=8080:8080 \
    --publish=8443:8443 \
    --publish=5555:5555 \
    --detach=true \
    sdhibit/rpi-openhab
```
# Known Issues

##Java getHostName() errors with host networking enabled

# Todo

* Custom SSL configuration
* Properly handle config volume mapping to host
* Allow addition of non-official addons from config volume
* USB device mapping
