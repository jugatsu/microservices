#!/usr/bin/env bash
#
# For using this script, first export GOOGLE_PROJECT environment
# variable with GCE project id, for example:
# export GOOGLE_PROJECT=project-example
#
set -e

# create 3 nodes
for i in {1..3}; do
  docker-machine create --driver google \
    --google-zone europe-west1-b \
    --google-machine-type n1-standard-1 \
    --google-open-port 80/tcp \
    --google-open-port 3000/tcp \
    --google-open-port 8080/tcp \
    --google-open-port 8081/tcp \
    --google-open-port 9000/tcp \
    --google-open-port 9090/tcp \
    --google-open-port 9292/tcp \
    --google-machine-image ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20171002 \
    node-${i}
done

# get manager's private ip
ip="$(docker-machine ssh node-1 ip addr show ens4 | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/')"

# init docker swarm
eval "$(docker-machine env node-1)"
docker swarm init --advertise-addr "$ip":2377

# get token
token=$(docker swarm join-token worker -q)

# join worker nodes
echo "Joining workers..."
for i in {2..3} ; do
  docker-machine ssh node-${i} sudo docker swarm join --token "$token" "$ip":2377
done
