# Raspberry PI TTN gateway
[![Build Status](https://travis-ci.org/netceteragroup/rpi-ttn-gateway.svg?branch=master)](https://travis-ci.org/netceteragroup/rpi-ttn-gateway) [![Docker Pulls](https://img.shields.io/docker/pulls/netceteragroup/rpi-ttn-gateway.svg)](https://hub.docker.com/r/netceteragroup/rpi-ttn-gateway/) [![Docker Stars](https://img.shields.io/docker/stars/netceteragroup/rpi-ttn-gateway.svg)](https://hub.docker.com/r/netceteragroup/rpi-ttn-gateway/) [![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/netceteragroup/rpi-ttn-gateway/blob/master/LICENSE)

Raspberry PI TTN gateway image based on Hypriot. This dockerfile is heavily influenced by the install script from [The Things Network iC880a-based gateway](https://github.com/ttn-zh/ic880a-gateway).

## Hardware Preperation
This image is made for and tested on a Raspberry Pi 3 together with a [IMST-iC880 SPI LoRaWAN concentrator](http://webshop.imst.de/ic880a-spi-lorawan-concentrator-868mhz.html).

## OS preparation
Here are the steps to get the host environment ready for this image:

1. Download the latest HypriotOS from here: https://blog.hypriot.com/downloads/
1. Install it on a SD card. Etcher is a easy-to-use tool for this: https://etcher.io/
	* Optional: place an empty `ssh` file in the root of the SD card to enable SSH access to the Pi
1. Put the SD card into your Raspberry Pi and power it up
1. Login with user `pirate` and password `hypriot` *Note*: default keyboard layout is [QWERTY](https://en.wikipedia.org/wiki/QWERTY). If you are using a [QWERTZ](https://en.wikipedia.org/wiki/QWERTZ) keyboard make sure you use the correct 'y' in the password
	* For SSH access: once the Pi has fully booted (the blinking LEDs have calmed down) it shows up with the default hostname `black-pearl` in your network.
1. Run `sudo apt-get update && sudo apt-get install raspi-config kbd`. During setup you can choose a different keyboard layout if you need
1. Run `sudo raspi-config` to
	* Set correct timezone: `4 Localisation Options > I2 Change Timezones`
	* Enable SPI interface: `5 Interfacing Options > P4 SPI > Yes`
1. Restart the Pi
1. Find the Pi MAC address and generate gateway EUI (required in next step) by running `cat /sys/class/net/eth0/address | awk -F\: '{print $1$2$3"fffe"$4$5$6}'`. This turns the [48-bit MAC address into EUI-64](https://en.wikipedia.org/wiki/MAC_address#Address_details), splits it in half and injects `fffe` (e.g. `b827eb8684a2` → `b827ebfffe8684a2`).
1. Run
	```bash
	docker run -it --privileged --net=host --restart=always \
	-e PI_RESET_PIN=<optional-see-explanation-below> \
	-e TTN_GATEWAY_SERVER_URL=<optional-see-explanation-below> \
	-e GATEWAY_EUI=<EUI-identified-in-previous-step> \
	-e GATEWAY_LAT=YOUR_LATITUDE \
	-e GATEWAY_LON=YOUR_LONGITUDE \
	-e GATEWAY_ALT=YOUR_ALTITUDE \
	-e GATEWAY_EMAIL=YOUR_EMAIL \
	-e GATEWAY_NAME=YOUR_GATEWAY_NAME \
	netceteragroup/rpi-ttn-gateway
	```
	* `PI_RESET_PIN` may or may not be required depending on how the concentrator is connected to the Pi. The default
	reset pin configured by [the start script](https://github.com/ttn-zh/ic880a-gateway/blob/spi/start.sh#L4) is 25.
	Installations with simple backplanes such as [the one from Gnz](https://www.tindie.com/products/gnz/imst-ic880a-lorawan-backplane-kit/)
	 can go with the default value. More elaborate backplanes might rewire the reset pin. The [one from CH2i](https://github.com/ch2i/iC880A-Raspberry-PI)
	 for example uses 17. Hence, you would say `docker run ... -e PI_RESET_PIN=17 ...`.
	 * `TTN_GATEWAY_SERVER_URL` URL of the TTN API endpoint server to use, the default is `eu1.cloud.thethings.network`. Server address for other regions are listed here:
  https://www.thethingsindustries.com/docs/getting-started/ttn/addresses/

## Running as a deamon
Item 9 above documents the Docker run command. If you would rather want to run the TTN container in daemon mode rather than interactive mode you would replace `-dt` with `-it`. This will put the Docker container process into the background and not block the CLI but you won't see the log output that normally spills to the console.

`docker logs <container-id>` could make that visible again if necessary. Or `docker attach <container-id>`. Or `docker exec -i <container-id> /bin/bash` and then poke around the container.

## Building the image yourself
To build a (potentially customized) image yourself do as follows:
```bash
$ git clone https://github.com/netceteragroup/rpi-ttn-gateway
$ cd rpi-ttn-gateway
$ docker build -t <your-handle-here>/rpi-ttn-gateway .
```
`<your-handle-here>` can be anything that is uniquely you (e.g. name) but you might also use `rpi-ttn-gateway` w/o any "prefix".

## Security considerations
Just a few obvious measures you can/should think about before you release your new gateway into the wild.
- It does help if the gateway is connected to the internet through a private network that's hard to penerate.
- Change the default password: connect to the Pi and run `passwd` to use a custom password.
- Change the default hostname: edit `/boot/device-init.yaml` and modify the `hostname` attribute ([source](https://blog.hypriot.com/faq/#how-can-i-change-the-hostname)).
