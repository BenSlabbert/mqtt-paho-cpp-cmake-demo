#!/usr/bin/env bash

set -ex

echo "Generating make files..."
cmake .

echo "Building..."
cmake --build . -- -j 2
