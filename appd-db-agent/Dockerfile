
FROM openjdk:8-jre-slim AS builder

MAINTAINER mark.prichard@appdynamics.com

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


FROM openjdk:8-jre-slim
RUN apt-get update -y; \
 apt-get install -y --no-install-recommends iproute2 procps sysstat dumb-init bash coreutils sed; \
	rm -rf /var/lib/apt/lists/*


COPY --from=builder /tmp /opt/appdynamics

ENV DB_AGENT_HOME /opt/appdynamics

WORKDIR ${DB_AGENT_HOME}


COPY startup.sh ./startup.sh
RUN chmod +x ./startup.sh


RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt


CMD "./startup.sh"