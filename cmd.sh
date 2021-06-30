#!/usr/bin/env bash

# change reset pin assignment if configured and not default
defaultResetPin=25
if [ -z "$PI_RESET_PIN" ]; then
  echo "PI_RESET_PIN env variable not set, reset pin assignment remains as-is (pin $defaultResetPin)"
else
  if [ "$PI_RESET_PIN" == $defaultResetPin ]; then
    echo "PI_RESET_PIN env variable is the same as the default pin assignment -> no changes"
  else
    echo "Re-assigning reset pin from $defaultResetPin to ${PI_RESET_PIN}"
    sed -i -e "s/SX1301_RESET_BCM_PIN=25/SX1301_RESET_BCM_PIN=${PI_RESET_PIN}/g" ./start.sh
  fi
fi

# TTN API server options
export TTN_GATEWAY_SERVER_URL=${TTN_GATEWAY_SERVER_URL:-eu1.cloud.thethings.network}
export TTN_GATEWAY_PORT_UP=${TTN_GATEWAY_PORT_UP:-1700}
export TTN_GATEWAY_PORT_DOWN=${TTN_GATEWAY_PORT_DOWN:-1700}

# inject the values provided by the user into the template
envsubst < local_conf_template.json > local_conf.json

# start script from https://github.com/ttn-zh/ic880a-gateway
./start.sh
