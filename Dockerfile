FROM resin/rpi-raspbian

# Install all required packages
RUN apt-get update && apt-get install -y git iproute2 swig libftdi-dev python-dev build-essential iputils-ping WiringPi

# Get the code for the ic880a-gateway
RUN git clone -b spi https://github.com/ttn-zh/ic880a-gateway.git ~/ic880a-gateway

ENV INSTALL_DIR /opt/ttn-gateway
RUN git clone https://github.com/devttys0/libmpsse.git $INSTALL_DIR/libmpsse
WORKDIR $INSTALL_DIR/libmpsse/src
RUN ./configure --disable-python
RUN make
RUN make install
RUN ldconfig

RUN git clone https://github.com/TheThingsNetwork/lora_gateway.git $INSTALL_DIR/lora_gateway

RUN cp $INSTALL_DIR/lora_gateway/libloragw/99-libftdi.rules /etc/udev/rules.d/99-libftdi.rules
RUN sed -i -e 's/PLATFORM= kerlink/PLATFORM= imst_rpi/g' $INSTALL_DIR/lora_gateway/libloragw/library.cfg

WORKDIR $INSTALL_DIR/lora_gateway
RUN make

RUN git clone https://github.com/TheThingsNetwork/packet_forwarder.git $INSTALL_DIR/packet_forwarder
WORKDIR $INSTALL_DIR/packet_forwarder 
RUN make
RUN mkdir $INSTALL_DIR/bin
RUN ln -s $INSTALL_DIR/packet_forwarder/poly_pkt_fwd/poly_pkt_fwd $INSTALL_DIR/bin/poly_pkt_fwd
RUN cp -f $INSTALL_DIR/packet_forwarder/poly_pkt_fwd/global_conf.json $INSTALL_DIR/bin/global_conf.json

RUN cp ~/ic880a-gateway/start.sh $INSTALL_DIR/bin/
RUN sed -i -e 's/SX1301_RESET_BCM_PIN=25/SX1301_RESET_BCM_PIN=17/g' $INSTALL_DIR/bin/start.sh
WORKDIR $INSTALL_DIR/bin
CMD echo "{\n\t\"gateway_conf\": {\n\t\t\"gateway_ID\": \"${GATEWAY_EUI}\",\n\t\t\"servers\": [ { \"server_address\": \"router.eu.thethings.network\", \"serv_port_up\": 1700, \"serv_port_down\": 1700, \"serv_enabled\": true } ], \n\t\t\"ref_latitude\": ${GATEWAY_LAT},\n\t\t\"ref_longitude\": ${GATEWAY_LON},\n\t\t\"ref_altitude\": ${GATEWAY_ALT},\n\t\t\"contact_email\": \"${GATEWAY_EMAIL}\",\n\t\t\"description\": \"${GATEWAY_NAME}\"  \n\t}\n}" > $INSTALL_DIR/bin/local_conf.json && ./start.sh

