
FROM openjdk:8-jdk-alpine

MAINTAINER mark.prichard@appdynamics.com

RUN apk add --no-cache bash gawk sed grep bc coreutils

ARG APPD_AGENT_VERSION 
ARG APPD_AGENT_SHA256

RUN mkdir -p /opt/appdynamics

COPY analytics-agent-${APPD_AGENT_VERSION}.zip /
RUN if [ "x${APPD_AGENT_SHA256}" != "x" ]; then \ 
 echo "${APPD_AGENT_SHA256} *analytics-agent-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && unzip -oq analytics-agent-${APPD_AGENT_VERSION}.zip -d /opt/appdynamics; \
   else \
     unzip -oq analytics-agent-${APPD_AGENT_VERSION}.zip -d /opt/appdynamics; \
   fi


ENV ANALYTICS_AGENT_HOME /opt/appdynamics/analytics-agent

COPY updateAnalyticsAgentConfig.sh /opt/appdynamics/updateAnalyticsAgentConfig.sh
RUN chmod +x /opt/appdynamics/updateAnalyticsAgentConfig.sh

COPY startup.sh /opt/appdynamics/startup.sh
RUN chmod +x /opt/appdynamics/startup.sh

RUN chgrp -R 0 /opt && \
    chmod -R g=u /opt

EXPOSE 9090

CMD "/opt/appdynamics/startup.sh"