DOCKER_UID=$(shell id -u)
DOCKER_UGID=$(shell id -g)
PWD=$(shell pwd)
CONFIG_FILE=yaota8266/config.h

default: help


help:  ## This help page
	@echo 'make targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-17s %s\n", $$1, $$2}'


docker-pull:  ## pull docker images
	docker pull jedie/micropython:latest


docker-build: docker-pull  ## pull and build docker images
	docker build \
    --build-arg "DOCKER_UID=${DOCKER_UID}" \
    --build-arg "DOCKER_UGID=${DOCKER_UGID}" \
    . \
    -t local/yaota8266:latest


update: docker-build  ## update git repositories/submodules, docker images and build local docker images
	git pull origin master
	git submodule update --init --recursive


shell: docker-build  ## start a bash shell in docker container "local/yaota8266:latest"
	docker run -it \
    -e "DOCKER_UID=${DOCKER_UID}" \
    -e "DOCKER_UGID=${DOCKER_UGID}" \
    --mount type=bind,src=${PWD}/yaota8266/,dst=/mpy/yaota8266/ \
    local/yaota8266:latest \
    /bin/bash


rsa-keys: ## Generate RSA keys and/or print RSA modulus line for copy&paste into config.h
	$(MAKE) -C yaota8266 rsa-keys

verify:  ## Check RSA key, config.h and compiled "yaota8266.bin"
	$(MAKE) -C yaota8266 verify

assert-yaota8266-setup:
	@if [ -f yaota8266/config.h ] ; \
	then \
		echo -n "\nyaota8266/config.h exists, ok.\n\n" ; \
	else \
		echo -n "\nERROR: Please create 'yaota8266/config.h' first!\n\n" ; \
		exit 1 ; \
	fi

	@if [ -f yaota8266/ota_client/priv.key ] ; \
	then \
		echo -n "\nyaota8266/ota_client/priv.key exists, ok.\n\n" ; \
	else \
		echo -n "\nERROR: RSA priv.key not found! Please call 'make yaota8266-rsa-keys' first!\n\n" ; \
		exit 1 ; \
	fi

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