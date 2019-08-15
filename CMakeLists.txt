set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY bin)

## Note: on OS X you should install XCode and the associated command-line tools
cmake_minimum_required(VERSION 3.10)
project("paho-mqtt-cpp-examples"
        VERSION "1.0.1"
        LANGUAGES CXX
        )

set(PAHO_CPP_LIB paho-mqtt3c)
## --- Library dependencies ---

set (THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

## include directories
#include_directories(${CMAKE_CURRENT_SOURCE_DIR})

## binary files
add_executable(sync_publish src/sync_publish.cpp)
add_executable(async_consume src/async_consume.cpp)
add_executable(async_publish src/async_publish.cpp)

## link binaries
target_link_libraries(sync_publish ${PAHO_CPP_LIB})
target_link_libraries(async_consume ${PAHO_CPP_LIB})
target_link_libraries(async_publish ${PAHO_CPP_LIB})

set(INSTALL_TARGETS
        sync_publish
        async_consume
        )

if(PAHO_WITH_SSL)
    ## SSL binary files
    add_executable(ssl_publish ssl_publish.cpp)

    ## link SSL binaries
    target_link_libraries(ssl_publish ${PAHO_CPP_LIB})

    set(INSTALL_TARGETS
            ${INSTALL_TARGETS}
            ssl_publish)

    add_definitions(-DOPENSSL)
endif()

## install binaries
install(TARGETS ${INSTALL_TARGETS} EXPORT PahoMqttCppSamples
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        )
