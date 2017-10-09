#!/usr/bin/env bash

docker-machine create --driver google --google-project otus-infra \
  --google-zone europe-west1-b \
  --google-machine-type g1-small \
  --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20171002 \
  docker-host
