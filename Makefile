DOCKER_UID=$(shell id -u)
DOCKER_UGID=$(shell id -g)
PWD=$(shell pwd)
CONFIG_FILE=yaota8266/config.h

default: help


help:  ## This help page
	@echo 'make targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-17s %s\n", $$1, $$2}'


check-user-id:
	@if [ ${DOCKER_UID} -eq '0' ] ; \
	then \
		echo -n "\nERROR: Please do not start with 'sudo' ! Run make targets as normal user!\n\n" ; \
		echo 1; \
	fi

docker-pull: check-user-id ## pull docker images
	docker pull jedie/micropython:latest


docker-build: docker-pull  ## pull and build docker images
	docker build \
    --build-arg "DOCKER_UID=${DOCKER_UID}" \
    --build-arg "DOCKER_UGID=${DOCKER_UGID}" \
    . \
    -t local/yaota8266:latest


update: check-user-id docker-build  ## update git repositories/submodules, docker images and build local docker images
	git pull origin master
	git submodule update --init --recursive


shell: docker-build  ## start a bash shell in docker container "local/yaota8266:latest"
	docker run -it \
    -e "DOCKER_UID=${DOCKER_UID}" \
    -e "DOCKER_UGID=${DOCKER_UGID}" \
    --mount type=bind,src=${PWD}/yaota8266/,dst=/mpy/yaota8266/ \
    local/yaota8266:latest \
    /bin/bash


rsa-keys: check-user-id ## Generate RSA keys and/or print RSA modulus line for copy&paste into config.h
	$(MAKE) -C yaota8266 rsa-keys

verify: check-user-id  ## Check RSA key, config.h and compiled "yaota8266.bin"
	$(MAKE) -C yaota8266 verify

assert-yaota8266-setup: check-user-id
	$(MAKE) -C yaota8266 assert-yaota8266-setup

build: update assert-yaota8266-setup ## compile the yaota8266/yaota8266.bin
	@if [ -f ${CONFIG_FILE} ] ; \
	then \
		echo -n "\n${CONFIG_FILE} exists, ok.\n\n" ; \
	else \
		echo -n "\nERROR: Please create '${CONFIG_FILE}' first!\n\n" ; \
		exit 1 ; \
	fi
	docker run \
		-e "DOCKER_UID=${DOCKER_UID}" \
		-e "DOCKER_UGID=${DOCKER_UGID}" \
		--mount type=bind,src=${PWD}/yaota8266/,dst=/mpy/yaota8266/ \
		local/yaota8266:latest \
		/bin/bash -c "cd /mpy/yaota8266/ && make clean && make build"