# docker-yaota8266

Compile yaota8266 via docker.

yaota8266 is yet another bootloader/over-the-air (OTA) update solution for ESP8266 WiFi SoC.

Origin yaota8266 sources are from: https://github.com/pfalcon/yaota8266
But currently this Project used a fork from: https://github.com/jedie/yaota8266 because of many missing patches. More info here: https://github.com/pfalcon/yaota8266/pull/27 see also: https://github.com/micropython/micropython/issues/2535#issuecomment-569740745

Docker image to compile is https://hub.docker.com/r/jedie/micropython builded via https://github.com/jedie/docker-micropython

## howto

```
# clone the sources:

~$ git clone https://github.com/jedie/docker-yaota8266.git
~& cd docker-yaota8266

Generate RSA keys and/or print RSA modulus line for copy&paste into config.h:

~/docker-yaota8266& make rsa-keys
...
Copy&paste this RSA modulus line into your config.h:
----------------------------------------------------------------------------------------------------
#define MODULUS "\xce\x4a\xaf\x65\x0d\x4a\x74\xda\xc1\x30\x59\x80\xcf\xdd\xe8\x2a\x2e\x1d\xf7\xa8\xc9\x6c\xa9\x4a\x2c\xb7\x8a\x5a\x2a\x25\xc0\x2b\x7b\x2f\x58\x4c\xa8\xcb\x82\x07\x06\x08\x7e\xff\x1f\xce\x47\x13\x67\x94\x5f\x9a\xac\x5e\x7d\xcf\x63\xf0\x08\xe9\x51\x98\x95\x01"
----------------------------------------------------------------------------------------------------
```

You must create your `yaota8266/config.h` (e.g.: make a copy of `yaota8266/config.h.example`)
Copy&paste RSA modulus line into your `config.h`

To compile `yaota8266.bin` call:
```
~/docker-yaota8266& make compile
```

The final `yaota8266.bin` is generated here: `~/docker-yaota8266/yaota8266/yaota8266.bin`


To display all make commands, type:
```
~/docker-yaota8266& make
make targets:
  help              This help page
  docker-pull       pull docker images
  docker-build      pull and build docker images
  update            update git repositories/submodules, docker images and build local docker images
  shell             start a bash shell in docker container "local/yaota8266:latest"
  compile           compile the yaota8266/yaota8266.bin
```
