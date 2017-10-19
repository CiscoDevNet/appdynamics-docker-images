FROM alpine AS builder

MAINTAINER mark.prichard@appdynamics.com

ARG APPD_AGENT_VERSION 
ARG APPD_AGENT_SHA256

RUN apk --no-cache add unzip

COPY AppServerAgent-${APPD_AGENT_VERSION}.zip / 
RUN echo "${APPD_AGENT_SHA256} *AppServerAgent-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && unzip -oq AppServerAgent-${APPD_AGENT_VERSION}.zip -d /tmp 

FROM jetty:9-jre8-alpine

USER root
RUN apk update && apk upgrade

USER jetty
COPY --from=builder /tmp /opt/appdynamics
ENV JAVA_AGENT -javaagent:/opt/appdynamics/javaagent.jar

CMD ["sh", "-c", "java $JAVA_AGENT ${APPDYNAMICS_NODE_PREFIX:+-Dappdynamics.agent.reuse.nodeName=true -Dappdynamics.agent.reuse.nodeName.prefix=${APPDYNAMICS_NODE_PREFIX}} -jar /usr/local/jetty/start.jar"]

