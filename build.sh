#!/usr/bin/env bash
#
# Run a build for all images.

set -uo pipefail

info() {
  printf "%s\n" "$@"
}

fatal() {
  printf "**********\n"
  printf "%s\n" "$@"
  printf "**********\n"
  exit 1
}

info "Building ..."
docker build -t netceteragroup/rpi-ttn-gateway .

if [[ $? -gt 0 ]]; then
  fatal "Build failed!"
else
  info "Build succeeded."
fi

exit 0
