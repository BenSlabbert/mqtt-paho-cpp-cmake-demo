FROM ubuntu:xenial

RUN apt update --fix-missing && \
    apt upgrade -y && \
#    apt install -y cppcheck libcppunit-dev git cmake cmake-data doxygen build-essential wget libssl-dev
    apt install -y cppcheck libcppunit-dev git doxygen build-essential wget libssl-dev

# install cmake
WORKDIR /
ARG CMAKE_VERSION=3.15.2
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz
RUN tar -xf cmake-${CMAKE_VERSION}.tar.gz
WORKDIR cmake-${CMAKE_VERSION}
RUN ./bootstrap && make && make install
RUN cmake --version

# install_catch2
ARG CATCH2_VERSION=2.9.1
RUN wget https://github.com/catchorg/Catch2/archive/v${CATCH2_VERSION}.tar.gz
RUN tar -xf v${CATCH2_VERSION}.tar.gz
WORKDIR Catch2-${CATCH2_VERSION}
RUN cmake -Bbuild -H. -DBUILD_TESTING=OFF
RUN env "PATH=$PATH" cmake --build build/ --target install

# Install Paho MQTT C (Need only paho-mqtt3a and paho-mqtt3as)
WORKDIR /
RUN git clone https://github.com/eclipse/paho.mqtt.c.git
WORKDIR paho.mqtt.c
RUN git checkout v1.3.0
RUN cmake -Bbuild -H. -DPAHO_WITH_SSL=ON
RUN env "PATH=$PATH" cmake --build build/ --target install
RUN ldconfig

WORKDIR /
RUN git clone https://github.com/eclipse/paho.mqtt.cpp
WORKDIR paho.mqtt.cpp
RUN cmake -Bbuild -H. -DPAHO_BUILD_DOCUMENTATION=TRUE -DPAHO_BUILD_SAMPLES=TRUE
RUN cmake --build build/ --target install
RUN ldconfig

WORKDIR /
RUN mkdir app
WORKDIR app
COPY . .
RUN bash build-all.sh
RUN ls bin
