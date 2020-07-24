
FROM openjdk:8-jre-slim AS builder

ARG APPD_AGENT_VERSION 
ARG APPD_AGENT_SHA256


RUN apt-get update -y; \
 apt-get install -y unzip

COPY dbagent-${APPD_AGENT_VERSION}.zip /
RUN if [ "x${APPD_AGENT_SHA256}" != "x" ]; then \ 
	echo "${APPD_AGENT_SHA256} *dbagent-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && unzip -oq dbagent-${APPD_AGENT_VERSION}.zip -d /tmp; \
    else \
     unzip -oq dbagent-${APPD_AGENT_VERSION}.zip -d /tmp; \
    fi

COPY LICENSE /tmp

FROM openjdk:8-jre-slim

ARG APPD_AGENT_VERSION 

MAINTAINER support@appdynamics.com

LABEL name="AppDynamics DB Agent" \
      vendor="AppDynamics" \
      version="${APPD_AGENT_VERSION}" \
      release="1" \
      url="https://www.appdynamics.com" \
      summary="AppDynamics solution for monitoring databases" \
      description="The DB Agent monitors database health and correlates it with the application performance"


COPY --from=builder /tmp /opt/appdynamics

ENV DB_AGENT_HOME /opt/appdynamics

WORKDIR ${DB_AGENT_HOME}


COPY startup.sh ./startup.sh
RUN chmod +x ./startup.sh


RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt


CMD "./startup.sh"