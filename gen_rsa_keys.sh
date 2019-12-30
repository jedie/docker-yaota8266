#!/bin/bash

DOCKER_UID=$(id -u)
DOCKER_UGID=$(id -g)
PWD=$(pwd)

set -ex

docker run \
    -e "DOCKER_UID=${DOCKER_UID}" \
    -e "DOCKER_UGID=${DOCKER_UGID}" \
    --mount type=bind,src=${PWD}/yaota8266/,dst=/mpy/yaota8266/ \
    local/micropython:latest \
    /mpy/yaota8266/ota-client/gen_keys.sh
