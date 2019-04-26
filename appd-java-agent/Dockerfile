FROM alpine AS builder

MAINTAINER mark.prichard@appdynamics.com

ARG APPD_AGENT_VERSION 
ARG APPD_AGENT_SHA256

RUN apk --no-cache add unzip

COPY AppServerAgent-${APPD_AGENT_VERSION}.zip /
RUN if [ "x${APPD_AGENT_SHA256}" != "x" ]; then \ 
 echo "${APPD_AGENT_SHA256} *AppServerAgent-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && unzip -oq AppServerAgent-${APPD_AGENT_VERSION}.zip -d /tmp; \
   else \
     unzip -oq AppServerAgent-${APPD_AGENT_VERSION}.zip -d /tmp; \
   fi

FROM openjdk:8-jre-alpine
RUN apk update && apk upgrade

COPY --from=builder /tmp /opt/appdynamics