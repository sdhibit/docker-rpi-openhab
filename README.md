# openHAB container on Raspberry Pi

Docker image of [openHAB](http://www.openhab.org/) 1.6.2 using the [rpi-java](https://github.com/sdhibit/docker-rpi-java) base image.

## Features

* Raspbian Jessie based 
* [Runit](http://smarden.org/runit/) process management
* [Touch UI](http://m-design.bg/greent/) and [HABmin](https://github.com/cdjackson/HABmin) pre-installed
* Demo Configuration starts when no configuration is found


# Building Image

```shell
$ git clone https://github.com/sdhibit/docker-rpi-openhab.git
$ cd docker-rpi-openhab
$ sudo docker build -t docker-rpi-openhab .
```
