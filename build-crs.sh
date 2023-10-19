﻿#!/bin/bash
set -e

if [ $DOCKER_CR_YANDEX = 'true' ] ; then
   cat $DOCKER_PASSWORD | docker login \
      --username $DOCKER_LOGIN \
      --password-stdin \
      $DOCKER_REGISTRY_URL
else
   docker login -u $DOCKER_LOGIN -p $DOCKER_PASSWORD $DOCKER_REGISTRY_URL
fi

if [ $DOCKER_SYSTEM_PRUNE = 'true' ] ; then
    docker system prune -af
fi

last_arg='.'
if [ $NO_CACHE = 'true' ] ; then
    last_arg='--no-cache .'
fi

docker build \
    --pull \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg ONEC_USERNAME=$ONEC_USERNAME \
    --build-arg ONEC_PASSWORD=$ONEC_PASSWORD \
    --build-arg ONEC_VERSION=$ONEC_VERSION \
    -t $DOCKER_REGISTRY_URL/crs:$ONEC_VERSION \
    -f crs/Dockerfile \
    $last_arg

docker push $DOCKER_REGISTRY_URL/crs:$ONEC_VERSION

docker build \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg ONEC_VERSION=$ONEC_VERSION \
    -t $DOCKER_REGISTRY_URL/crs-apache:$ONEC_VERSION \
    -f crs-apache/Dockerfile \
    $last_arg

docker push $DOCKER_REGISTRY_URL/crs-apache:$ONEC_VERSION
