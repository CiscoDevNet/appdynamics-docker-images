
FROM openjdk:8-jre-slim AS builder

MAINTAINER mark.prichard@appdynamics.com

ARG APPD_AGENT_VERSION 
ARG APPD_AGENT_SHA256

COPY MachineAgent-${APPD_AGENT_VERSION}.zip /
RUN if [ "x${APPD_AGENT_SHA256}" != "x" ]; then \ 
	echo "${APPD_AGENT_SHA256} *MachineAgent-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && unzip -oq MachineAgent-${APPD_AGENT_VERSION}.zip -d /tmp; \
    else \
     unzip -oq MachineAgent-${APPD_AGENT_VERSION}.zip -d /tmp; \
    fi


FROM openjdk:8-jre-slim

RUN apt-get update && apt-get -y upgrade && apt-get install -y unzip bash gawk sed grep bc coreutils && apt-get install -y apt-utils && apt-get install -y iproute2 && apt-get install -y procps && apt-get install -y sysstat && apt-get install -y net-tools tcpdump curl sysvinit-utils openssh-client && rm -rf /var/lib/apt/lists/*

RUN apt-get clean autoclean
RUN apt-get autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY --from=builder /tmp /opt/appdynamics

ENV MACHINE_AGENT_HOME /opt/appdynamics

ENV NETVIZ_AGENT_HOME ${MACHINE_AGENT_HOME}/extensions/NetVizExtension

RUN ${NETVIZ_AGENT_HOME}/agent/install.sh

WORKDIR ${MACHINE_AGENT_HOME}

COPY updateNetViz.sh ./updateNetViz.sh
RUN chmod +x ./updateNetViz.sh

COPY updateAnalyticsAgent.sh ./updateAnalyticsAgent.sh
RUN chmod +x ./updateAnalyticsAgent.sh

COPY startup.sh ./startup.sh
RUN chmod +x ./startup.sh


RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt

EXPOSE 9090
EXPOSE 3892


CMD "./startup.sh"