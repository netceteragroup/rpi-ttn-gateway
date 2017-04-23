#!/usr/bin/env bash
#
# Run a test for all images.

set -uo pipefail
FILE=docker.output

# Run the freshly built image and execute a dummy command capturing its output
docker run netceteragroup/rpi-ttn-gateway cat /opt/ttn-gateway/bin/start.sh  > $FILE

if [ -f $FILE ]; then
  if grep -q "# Reset iC880a PIN" docker.output && grep -q "./poly_pkt_fwd" docker.output; then
    printf "Docker image test succeeded\n"
    rm -f $FILE
  else
    printf "Docker image test failed, output doesn't contain expected strings\n"
    rm -f $FILE
    exit 1
  fi
else
   echo "File $FILE does not exist."
   exit 1
fi

exit 0
