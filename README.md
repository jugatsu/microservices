# Description

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
