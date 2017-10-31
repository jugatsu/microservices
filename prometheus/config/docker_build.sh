#!/bin/bash

NAME="$USER_NAME/prometheus"
TAG=`git log -1 --pretty=%h`
IMG="$NAME:$TAG"
LATEST="$NAME:latest"

docker build --build-arg VCS_REF=`git rev-parse --abbrev-ref HEAD` \
  --build-arg BUILD_DATE=`date -u +”%Y-%m-%dT%H:%M:%SZ”` \
  -t $IMG .

docker tag $IMG $LATEST
