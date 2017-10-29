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

# Usage

Run using `docker-compose`:

```bash
$ docker-compose up -d
```

## Build images locally

To build `post` container run:

```bash
$ docker build -t post:latest post-py/
```

To build `comment` container run:

```bash
$ docker build -t comment:latest comment/
```

To build `UI` container run:

```bash
$ docker build -t ui:latest ui/
```
