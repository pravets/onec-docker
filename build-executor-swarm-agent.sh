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

executor_version=$EXECUTOR_VERSION
executor_escaped="${executor_version// /_}"

docker build \
    --pull \
    --build-arg ONEC_USERNAME=$ONEC_USERNAME \
    --build-arg ONEC_PASSWORD=$ONEC_PASSWORD \
    --build-arg EXECUTOR_VERSION="$EXECUTOR_VERSION" \
    -t $DOCKER_REGISTRY_URL/executor:$executor_escaped \
    -f executor/Dockerfile \
    $last_arg

docker push $DOCKER_REGISTRY_URL/executor:$executor_escaped

#docker build \
#    --build-arg DOCKER_REGISTRY_URL=$DOCKER_REGISTRY_URL \
#    --build-arg BASE_IMAGE=edt \
#    --build-arg BASE_TAG=$edt_escaped \
#    -t $DOCKER_REGISTRY_URL/edt-agent:$edt_escaped \
#	-f swarm-jenkins-agent/Dockerfile \
#    $last_arg
#
#docker push $DOCKER_REGISTRY_URL/edt-agent:$edt_escaped
