#!/bin/bash
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
    -t $DOCKER_REGISTRY_URL/base-ones-server:$ONEC_VERSION \
    -f base-server/Dockerfile \
    $last_arg

docker push $DOCKER_REGISTRY_URL/base-ones-server:$ONEC_VERSION

docker build \
    --pull \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg ONEC_USERNAME=$ONEC_USERNAME \
    --build-arg ONEC_PASSWORD=$ONEC_PASSWORD \
    --build-arg ONEC_VERSION=$ONEC_VERSION \
    --build-arg EXECUTOR_VERSION=$EXECUTOR_VERSION \
    -t $DOCKER_REGISTRY_URL/base-ones-server-scripted:$ONEC_VERSION \
    -f base-server-scripted/Dockerfile \
    $last_arg

docker push $DOCKER_REGISTRY_URL/base-ones-server-scripted:$ONEC_VERSION

docker build \
    --pull \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg ONEC_VERSION=$ONEC_VERSION \
    -t $DOCKER_REGISTRY_URL/ibcmd:$ONEC_VERSION \
    -f ibcmd/Dockerfile \
    $last_arg

docker push $DOCKER_REGISTRY_URL/ibcmd:$ONEC_VERSION

docker build \
    --pull \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg ONEC_VERSION=$ONEC_VERSION \
    -t $DOCKER_REGISTRY_URL/ibsrv:$ONEC_VERSION \
    -f ibsrv/Dockerfile \
    $last_arg

docker push $DOCKER_REGISTRY_URL/ibsrv:$ONEC_VERSION

docker build \
    --pull \
    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
    --build-arg ONEC_VERSION=$ONEC_VERSION \
    -t $DOCKER_REGISTRY_URL/rac:$ONEC_VERSION \
    -f rac/Dockerfile \
    $last_arg

docker push $DOCKER_REGISTRY_URL/rac:$ONEC_VERSION

