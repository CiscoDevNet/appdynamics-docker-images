#!/usr/bin/env bash

IMAGE_NAME=appdynamics/machine-agent-netviz
if [ "x$2" != "x" ]; then
  IMAGE_NAME=$2
fi
FILE="Dockerfile"
if [ "x$3" != "x" ]; then
  FILE=$3
fi
docker build --build-arg NETVIZ_ZIP_PKG=appd-netviz-$1.zip -t ${IMAGE_NAME}:$1 --no-cache -f ${FILE}  .