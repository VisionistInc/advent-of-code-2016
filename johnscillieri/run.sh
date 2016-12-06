#!/bin/bash
docker build -t nim_build . > /dev/null
pushd $1 > /dev/null
docker run -v `pwd`:/src --rm nim_build nim c --hints:off -r -d:release main.nim
popd > /dev/null
