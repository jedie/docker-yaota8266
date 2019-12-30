# docker-yaota8266

Compile yaota8266 via docker.

yaota8266 is yet another bootloader/over-the-air (OTA) update solution for ESP8266 WiFi SoC.

yaota8266 sources are here:

 * https://github.com/pfalcon/yaota8266

Docker image to compile is https://hub.docker.com/r/jedie/micropython builded via https://github.com/jedie/docker-micropython

## howto

```
# clone the sources:

~$ git clone https://github.com/jedie/docker-yaota8266.git
~& cd docker-yaota8266

# pull and build the docker image:

~/docker-yaota8266& ./docker_pull_build.sh

Generate RSA keys and/or print RSA modulus line for copy&paste into config.h::

~/docker-yaota8266& ./gen_rsa_keys.sh
```

You must create your `yaota8266/config.h` (e.g.: make a copy of `yaota8266/config.h.example`)
Copy&paste RSA modulus line into your `config.h`

To compile `yaota8266.bin` call:
```
~/docker-yaota8266& ./make.sh
```

The final `yaota8266.bin` is generated here: `~/docker-yaota8266/yaota8266/yaota8266.bin`
