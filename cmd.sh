#!/usr/bin/env bash

# inject the values provided by the user into the template
envsubst < local_conf_template.json > local_conf.json
# start script from https://github.com/ttn-zh/ic880a-gateway
./start.sh
