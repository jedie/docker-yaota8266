#!/bin/bash

# used docker image made via: https://github.com/jedie/docker-micropython

DOCKER_UID=$(id -u)
DOCKER_UGID=$(id -g)

set -ex

(
  cd yaota8266
  git submodule update --init
)

docker run -it \
    -e "DOCKER_UID=${DOCKER_UID}" \
    -e "DOCKER_UGID=${DOCKER_UGID}" \
    --mount type=bind,src=${PWD}/yaota8266/,dst=/mpy/yaota8266/ \
    --mount type=bind,src=${PWD}/yaota8266_scripts/,dst=/mpy/yaota8266_scripts/ \
    local/yaota8266:latest \
    /bin/bash -c "cd /mpy/yaota8266/ && make"
