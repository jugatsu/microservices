# Description

![Cloud Native](https://img.shields.io/badge/cloud-native-81bfe8.svg)
![Uses Docker](https://img.shields.io/badge/uses-docker-50a3cf.svg)
![Uses Kubernetes](https://img.shields.io/badge/uses-kubernetes-3176e1.svg)
![Uses Helm](https://img.shields.io/badge/uses-helm-10a3eb.svg)
![Uses Terraform](https://img.shields.io/badge/uses-terraform-5956e3.svg)

Dockerized reddit-like app https://github.com/Artemmkin/reddit.

## Directory structure:

#### `/deploy`

Configuration to provision the application onto Docker Swarm or Kubernetes.

#### `/infra`

Terraform configuration for GKE cluster.

#### `/scripts`

`create-docker-host.sh`: example script to provision Docker host via `docker-machine` in GCE.

`create-docker-swarm-gce`: example script to provision Docker Swarm cluster via `docker-machine` in GCE.

#### `/src`

Source code for all microservices.

#### `/monitoring`

`prometheus/`: Dockerfiles for building [Prometheus](https://github.com/prometheus/prometheus) stack.

`grafana/`: [Grafana](https://grafana.com) dashboards.

# Usage

Run using `docker-compose`:

```bash
$ docker-compose up -d
```

## Build images locally

```bash
$ make all
```
