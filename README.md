# Description

Dockerized reddit-like app https://github.com/Artemmkin/reddit.

## Directory structure:

#### `/monolith`

Contains files for building monolith Docker image with [reddit](https://github.com/Artemmkin/reddit) app.

#### `/post-py`

Contains files for building `post` microservice.

#### `/comment`

Contains files for building `comment` microservice.

#### `/ui`

Contains files for building `UI` microservice.

#### `/scripts`

`create-docker-host.sh`: example script to provision docker host via `docker-machine` in GCE.

#### `/prometheus`

`blackbox-exporter/`: Dockerfile and config file for building [blackbox_exporter](https://github.com/prometheus/blackbox_exporter) image.

`config/`: Dockerfile and config file for building [prometheus](https://github.com/prometheus/prometheus) image.

# Usage

Run using `docker-compose`:

```bash
$ docker-compose up -d
```

## Build images locally

To build `post` container run from `post-py` folder:

```bash
$ . ./docker_build.sh
```

To build `comment` container run from `comment` folder:

```bash
$ . ./docker_build.sh
```

To build `ui` container run from `ui` folder:

```bash
$ . ./docker_build.sh
```
