ARG DOCKER_REGISTRY_URL
ARG ONEC_VERSION
ARG BASE_IMAGE=base-ones-server

FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${ONEC_VERSION}

ARG WORK_DIR=/home/usr1cv8/ibsrv

RUN mkdir -p ${WORK_DIR}{ib,config}

VOLUME ["/home/usr1cv8/ibsrv/ib", "/home/usr1cv8/ibsrv/config"] 

ENTRYPOINT ["ibsrv"]

