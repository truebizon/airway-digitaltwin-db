#!/bin/bash
set -e
BUILD_DIR=${BUILD_DIR:-build}
mkdir -p "$BUILD_DIR"
SRC_FILES=$(find src -name '*.cpp')
INCLUDE_FLAGS="-I$(brew --prefix proj)/include -I$(brew --prefix bullet)/include -I$(brew --prefix sqlite)/include -I$(brew --prefix mysql)/include"
clang++ -std=c++17 -c $SRC_FILES $INCLUDE_FLAGS
ar rcs "$BUILD_DIR/libSpatialId.a" *.o
rm *.o
echo "Library built at $BUILD_DIR/libSpatialId.a"

