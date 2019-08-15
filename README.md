# paho-mqtt-cpp-examples

## Built

See the `Dockerfile`
Run `docker build .` which will install all dependencies and build the 3 artifacts.
You can use `docker cp` to get them out of the container

## Dependencies

### [paho.mqtt.c](https://github.com/eclipse/paho.mqtt.c) 

build with `-DPAHO_WITH_SSL=OFF` for a non-ssl build (there are dependencies on OpenSSL crypto libs)

### [paho.mqtt.cpp](https://github.com/eclipse/paho.mqtt.cpp) 

depends on `paho.mqtt.c` build with `-DPAHO_WITH_SSL=OFF`

### [spdlog](https://github.com/gabime/spdlog) 

build with `-DBUILD_TESTING=OFF` otherwise you will need the [benchmark](https://github.com/google/benchmark) dependency (I think it is this one)
