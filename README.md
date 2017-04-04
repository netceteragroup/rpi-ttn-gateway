# rpi-ttn-gateway
Raspberry PI TTN gateway image based on Hypriot. This dockerfile is heavily influenced by the install script from https://github.com/ttn-zh/ic880a-gateway

## Hardware Preperation
This image is made for and tested on a Raspberry Pi 3 together with a IMST-iC880 SPI LoRaWAN concentrator:
http://webshop.imst.de/ic880a-spi-lorawan-concentrator-868mhz.html


## OS preparation
Here are the steps to get the host environment ready for this image:
1. Download the latest HypriotOS from here: https://blog.hypriot.com/downloads/
2. Install it on a SD card. Etcher is a easy-to-use tool for this: https://etcher.io/
3. Put the SD card into your Raspberry Pi and power it up
4. Login with user pirate and password hypriot *Note*: default is a QWERTY keyboard. If you are using a QWERTZ keyboard make sure you use the correct 'y' in the password
5. Run `sudo apt-get update && sudo apt-get install raspi-config kbd`. During setup you can choose a different keyboard layout if you need
6. Run `raspi-config` and enable SPI interface `5 Interfacing Options > P4 SPI > Yes` and restart the Pi
7. Run 
   ```bash
    docker run -it --privileged --net=host --restart=always \
    -e GATEWAY_EUI=YOUR_MAC_ADDRESS \
    -e GATEWAY_LAT=YOUR_LATITUDE \
    -e GATEWAY_LON=YOUR_LONGITUDE \
    -e GATEWAY_ALT=YOUR_ALTITUDE \
    -e GATEAY_EMAIL=YOUR_EMAIL \
    -e GATEWAY_NAME=YOUR_GATEWAY_NAME \
    netceteragroup/rpi-ttn-gateway
    ```

## Optional: Building the image
To build the image run
```bash
docker build . 
