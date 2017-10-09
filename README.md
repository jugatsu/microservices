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

* `create-docker-host.sh`: example script to provision docker host via `docker-machine` in GCE.
* `run-containers.sh`: script for running all containers for [reddit](https://github.com/Artemmkin/reddit) app.

# Usage

Run using images from the Docker Hub repository:

```bash
$ scripts/run-containers.sh
```

## Build images locally

To build `post` container run:

```bash
$ docker build -t post:1.0 -f post-py/Dockerfile-1.0 post-py/
$ docker build -t post:latest post-py/
```

To build `comment` container run:

```bash
$ docker build -t comment:1.0 -f comment/Dockerfile-1.0 comment/
$ docker build -t comment:latest comment/
```

To build `UI` container run:

```bash
$ docker build -t ui:1.0 -f ui/Dockerfile-1.0 ui
$ docker build -t ui:2.0 -f ui/Dockerfile-2.0 ui
$ docker build -t ui:latest ui/
```
