FROM sdhibit/rpi-java:latest
MAINTAINER Steve Hibit <sdhibit@gmail.com>

RUN set -x \
  && apt-get update \
  && apt-get install -y \
    unzip \
    wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

ENV APP_HOME    /opt/openhab
ENV APP_CONFIG  /etc/openhab
ENV APP_DATA    /var/lib/openhab
ENV APP_LOG	/var/log/openhab
ENV APP_VERSION 1.6.2
ENV PKG_BASE	distribution-${APP_VERSION}
ENV APP_BASEURL https://github.com/openhab/openhab/releases/download/v${APP_VERSION}/${PKG_BASE}

RUN set -x \
 && groupadd -r -g 300 openhab \
 && useradd -r -u 300 -g openhab openhab \
 && mkdir -p "${APP_HOME}" "${APP_DATA}" "${APP_LOG}" \
 && mkdir -p "${APP_HOME}/lib" "${APP_HOME}/addons-available" \
 && mkdir -p "${APP_DATA}/workspace" \
 && wget -O /tmp/runtime.zip "${APP_BASEURL}"-runtime.zip \
 && wget -O /tmp/addons.zip "${APP_BASEURL}"-addons.zip \
 && wget -O /tmp/demo-configuration.zip "${APP_BASEURL}"-demo-configuration.zip \
 && wget -O /tmp/greent.zip "${APP_BASEURL}"-greent.zip \
 && unzip -o -d "${APP_HOME}" /tmp/runtime.zip \
 && unzip -o -d "${APP_HOME}/addons-available" /tmp/addons.zip \
 && unzip -o -d "${APP_HOME}/demo" /tmp/demo-configuration.zip \
 && unzip -o -d "${APP_HOME}/webapps/" /tmp/greent.zip \
 && mv "${APP_HOME}"/configurations "${APP_CONFIG}"/ \
 && ln -s "${APP_CONFIG}" "${APP_HOME}"/configurations \ 
 && chown -R openhab:openhab "${APP_HOME}" "${APP_CONFIG}" "${APP_DATA}" "${APP_LOG}"

ADD openhab-launcher.sh "${APP_HOME}"/openhab-launcher.sh
ADD openhab-service.sh /etc/service/openhab/run
