#!/usr/bin/env bash
#
# Push all images.

set -uo pipefail

printf "Pushing to Docker Hub...\n"
docker push netceteragroup/rpi-ttn-gateway

exit 0
