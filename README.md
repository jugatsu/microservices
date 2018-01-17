# Description

![Cloud Native](https://img.shields.io/badge/cloud-native-81bfe8.svg)
![Uses Docker](https://img.shields.io/badge/uses-docker-50a3cf.svg)
![Uses Kubernetes](https://img.shields.io/badge/uses-kubernetes-3176e1.svg)
![Uses Helm](https://img.shields.io/badge/uses-helm-10a3eb.svg)
![Uses Terraform](https://img.shields.io/badge/uses-terraform-5956e3.svg)

Dockerized reddit-like app https://github.com/Artemmkin/reddit.

## Directory structure:

#### `/src`

Source code for all microservices.

#### `/scripts`

`create-docker-host.sh`: example script to provision docker host via `docker-machine` in GCE.

#### `/monitoring`

`prometheus/`: Dockerfiles for building [prometheus](https://github.com/prometheus/prometheus) stack.

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
