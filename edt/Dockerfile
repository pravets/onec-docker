ARG DOCKER_REGISTRY_URL=library
ARG BASE_IMAGE=eclipse-temurin
ARG BASE_TAG=11

FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG}

LABEL maintainer="Nikita Gryzlov <NikGryzlov@1bit.com>, FirstBit"

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG EDT_VERSION=2021.3
ARG EDT_FOLDER=1c-edt-2021.3.1+1-x86_64

ENV installer_type=edt \
  ONEC_VERSION=${EDT_VERSION}

COPY ./scripts/download_og.sh /download_og.sh


WORKDIR /tmp

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    # downloader dependencies
    curl \
    # edt dependencies
    libgtk-3-0 \
    locales \
  && rm -rf  \
    /var/lib/apt/lists/* \
    /var/cache/debconf \
    /tmp/* \
  && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

ARG downloads=downloads/developmenttools10/${ONEC_VERSION}
ENV LANG ru_RU.UTF-8

# Install EDT
COPY ./distr ./${downloads}
RUN rm ./${downloads}/.gitkeep \
  && rm -rf ${downloads}/server*.tar.gz \
  && rm -rf ${downloads}/deb*.tar.gz \
  && rm -rf ${downloads}/thin.client*.tar.gz \
  && if [ -z "$(ls -A ${downloads})" ]; then \
  chmod +x /download_og.sh \
  && sync; /download_og.sh; \
  fi \
  && ls ${downloads} \
  && for file in ${downloads}/*.tar.gz; do tar -zxf "$file"; done \
  && rm -rf ${downloads}/*.tar.gz \
  && ./1ce-installer-cli install all --ignore-hardware-checks --ignore-signature-warnings \
  && rm -rf /tmp/* \
  && export edt_path=$(dirname $(find /opt/1C/1CE -name 1cedt)) \
  && mv $(dirname $(find /opt/1C/1CE -name ring)) /opt/1C/1CE/components/1c-enterprise-ring \

# Install Disable Editing Plugin
  && $edt_path/1cedt -clean -purgeHistory -application org.eclipse.equinox.p2.director -noSplash -repository 'https://marmyshev.gitlab.io/edt-editing/update' -installIUs 'org.mard.dt.editing.feature.feature.group' \

# cleanup
  && rm -f $edt_path/configuration/*.log \
  && rm -rf $edt_path/configuration/org.eclipse.core.runtime \
  && rm -rf $edt_path/configuration/org.eclipse.osgi \
  && rm -rf $edt_path/plugin-development \
  && rm -f $edt_path/plugins/com._1c.g5.v8.dt.platform.doc_*.jar \
  && rm -f $edt_path/plugins/com._1c.g5.v8.dt.product.doc_*.jar \
  && rm -f $edt_path/plugins/org.eclipse.egit.doc_*.jar \
  && rm -f $edt_path/plugins/org.eclipse.platform.doc_*.jar \
  && rm -rf /tmp/*

ENV PATH="/opt/1C/1CE/components/$EDT_FOLDER:/opt/1C/1CE/components/1c-enterprise-ring:$PATH"
