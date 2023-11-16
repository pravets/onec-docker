ARG DOCKER_REGISTRY_URL=library
ARG BASE_IMAGE=ubuntu
ARG BASE_TAG=22.04

FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG}

LABEL maintainer="Iosif Pravets <i@pravets.ru>"

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG EXECUTOR_VERSION=3.0.2.2

ENV installer_type=executor \
  ONEC_VERSION=${EXECUTOR_VERSION}

COPY ./scripts/download_og.sh /download_og.sh

WORKDIR /tmp

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    locales \
    ca-certificates \
    # downloader dependencies
    curl \
    # build dependencies
    unzip \
  && rm -rf  \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
    /tmp/* \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

ARG downloads=downloads/executor/${ONEC_VERSION}
ENV LANG ru_RU.UTF-8

# Install Executor
COPY ./distr ./${downloads}
RUN rm ./${downloads}/.gitkeep \
  && rm -rf ${downloads}/server*.tar.gz \
  && rm -rf ${downloads}/deb*.tar.gz \
  && rm -rf ${downloads}/thin.client*.tar.gz \
  && rm -rf ${downloads}/1c_edt*.tar.gz \
  && if [ -z "$(ls -A ${downloads})" ]; then \
  chmod +x /download_og.sh \
  && sync; /download_og.sh; \
  fi \
  && ls ${downloads} \
  && for file in ${downloads}/*.zip; do unzip "$file"; done \
  && rm -rf ${downloads}/*.zip \ 
  && mkdir /opt/executor \
  && cp -R * /opt/executor \
# cleanup
  && rm -rf /tmp/* \
  && apt purge -y unzip

ENV PATH="/opt/executor:$PATH"
