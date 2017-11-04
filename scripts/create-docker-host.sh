#!/usr/bin/env bash
#
# For using this script, first export GOOGLE_PROJECT environment
# variable with GCE project id, for example:
# export GOOGLE_PROJECT=project-example
#

docker-machine create --driver google \
  --google-zone europe-west1-b \
  --google-machine-type n1-standard-1 \
  --google-open-port 9090/tcp \
  --google-open-port 9292/tcp \
  --google-open-port 3000/tcp \
  --google-open-port 8080/tcp \
  --google-machine-image ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20171002 \
  docker-host
