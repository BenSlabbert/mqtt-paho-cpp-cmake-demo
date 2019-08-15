#!/usr/bin/env bash

set -ex

cmake .
cmake --build . -- -j 2
