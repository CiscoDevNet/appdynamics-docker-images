FROM debian AS builder

MAINTAINER mark.prichard@appdynamics.com

ARG APPD_AGENT_VERSION 
ARG APPD_AGENT_SHA256

RUN apt-get update && apt-get install -y --no-install-recommends  unzip \
        && rm -rf /var/lib/apt/lists/*

COPY AppServerAgent-${APPD_AGENT_VERSION}.zip / 
RUN echo "${APPD_AGENT_SHA256} *AppServerAgent-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && unzip -oq AppServerAgent-${APPD_AGENT_VERSION}.zip -d /tmp 

FROM tomcat:7-jre8
RUN apt-get update && apt-get -y upgrade
COPY --from=builder /tmp /opt/appdynamics
COPY setenv.sh ${CATALINA_HOME}/bin/
