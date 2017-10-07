#!/usr/bin/env bash

# ensure reddit network is present
if ! docker network inspect reddit > /dev/null 2>&1; then
  docker network create --driver bridge reddit
fi

# run database container
docker run -d --name=db \
  --network=reddit \
  --network-alias=db \
  --mount source=reddit_db,target=/data/db \
  mongo:latest

# run container with post service
docker run -d --name=post \
  --network=reddit \
  --env 'POST_DATABASE_HOST=db' \
  --network-alias=post_service \
  post:latest

# run container with comment service
docker run -d --name=comment \
  --network=reddit \
  --env 'COMMENT_DATABASE_HOST=db' \
  --network-alias=comment_service \
  comment:latest

# run container with UI service
docker run -d --name=ui \
  --network=reddit -p 9292:9292 \
  --env 'POST_SERVICE_HOST=post_service' \
  --env 'COMMENT_SERVICE_HOST=comment_service' \
  ui:latest
