#!/usr/bin/env bash
#
# Run a build for all images.

set -uo pipefail

printf "Starting Docker build...\n"
docker build -t netceteragroup/rpi-ttn-gateway .

exit 0
