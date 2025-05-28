#!/bin/bash
set -e
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
BUILD_DIR=${BUILD_DIR:-$SCRIPT_DIR/build}
mkdir -p "$BUILD_DIR"

# Build SpatialId library if available
if [ -d "$SCRIPT_DIR/../SpatialId" ]; then
    (cd "$SCRIPT_DIR/../SpatialId" && ./build-macos.sh)
    SPATIAL_LIB="-L$SCRIPT_DIR/../SpatialId/build -lSpatialId"
fi

INCLUDES="-I$SCRIPT_DIR/../SpatialId/src -I$(brew --prefix proj)/include -I$(brew --prefix bullet)/include -I$(brew --prefix sqlite)/include -I$(brew --prefix mysql)/include"
LIBS="-lproj -lBulletDynamics -lBulletCollision -lLinearMath -lsqlite3 -lmysqlclient $SPATIAL_LIB"

for dir in $(find "$SCRIPT_DIR" -maxdepth 1 -type d ! -path "$SCRIPT_DIR" -printf '%f\n'); do
    SRC=$(find "$dir" -maxdepth 1 -name '*.cpp' 2>/dev/null)
    if [ -n "$SRC" ]; then
        echo "Building $dir"
        clang++ -std=c++17 $SRC $INCLUDES $LIBS -o "$BUILD_DIR/$dir" || true
    fi
done

echo "Build finished. Executables are under $BUILD_DIR"

