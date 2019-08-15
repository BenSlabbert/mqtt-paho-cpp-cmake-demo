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
ARG PAHO_MQTT_C_VERSION=1.3.0
WORKDIR /
RUN git clone https://github.com/eclipse/paho.mqtt.c.git
WORKDIR paho.mqtt.c
RUN git checkout v${PAHO_MQTT_C_VERSION}
RUN cmake -Bbuild -H. -DPAHO_WITH_SSL=ON
RUN env "PATH=$PATH" cmake --build build/ --target install
RUN ldconfig

# Install Paho MQTT C++
ARG PAHO_MQTT_CPP_VERSION=1.0.1
WORKDIR /
RUN git clone https://github.com/eclipse/paho.mqtt.cpp.git
WORKDIR paho.mqtt.cpp
RUN git checkout v${PAHO_MQTT_CPP_VERSION}
RUN cmake -Bbuild -H. -DPAHO_BUILD_DOCUMENTATION=TRUE -DPAHO_BUILD_SAMPLES=TRUE
RUN cmake --build build/ --target install
RUN ldconfig

# Install benchmark
ARG GOOGLE_BENCHMARK_VERSION=1.5.0
ARG GOOGLETEST_VERSION=1.8.1
WORKDIR /
RUN git clone https://github.com/google/benchmark.git
RUN git clone https://github.com/google/googletest.git benchmark/googletest
WORKDIR benchmark
RUN git checkout v${GOOGLE_BENCHMARK_VERSION}
WORKDIR googletest
RUN git checkout release-${GOOGLETEST_VERSION}
WORKDIR /benchmark
RUN mkdir build
WORKDIR build
RUN cmake ../
RUN make
RUN make test
RUN make install
RUN ldconfig

# Install spdlog
ARG SPDLOG_VERSION=1.3.1
WORKDIR /
RUN git clone https://github.com/gabime/spdlog.git
WORKDIR spdlog
RUN git checkout v${SPDLOG_VERSION}
RUN mkdir build
WORKDIR build
RUN cmake ../ -DSPDLOG_BUILD_BENCH=FALSE && make -j
RUN make install
RUN ldconfig

# Install app
WORKDIR /
RUN mkdir app
WORKDIR app
COPY . .
RUN bash build-all.sh
RUN echo "Built binaries:" && ls -alh bin

# todo copy from /app/bin/async_consume /app/bin/async_publish /app/bin/sync_publish the built binaries
