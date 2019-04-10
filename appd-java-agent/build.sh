#!/usr/bin/env bash

IMAGE_NAME=appdynamics/java-agent
if [ "x$3" != "x" ]; then
  IMAGE_NAME=$3
fi
docker build --build-arg APPD_AGENT_VERSION=$1 --build-arg  APPD_AGENT_SHA256=$2 -t ${IMAGE_NAME}:$1 --no-cache  .