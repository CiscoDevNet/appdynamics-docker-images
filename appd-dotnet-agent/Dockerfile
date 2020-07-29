FROM alpine AS builder

ARG APPD_AGENT_VERSION 
ARG APPD_AGENT_SHA256

RUN apk --no-cache add unzip

ADD LICENSE /licenses/

COPY AppDynamics-DotNetCore-${APPD_AGENT_VERSION}.zip /
RUN if [ "x${APPD_AGENT_SHA256}" != "x" ]; then \ 
 echo "${APPD_AGENT_SHA256} *AppDynamics-DotNetCore-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && unzip -oq AppDynamics-DotNetCore-${APPD_AGENT_VERSION}.zip -d /tmp; \
   else \
     unzip -oq AppDynamics-DotNetCore-${APPD_AGENT_VERSION}.zip -d /tmp; \
   fi

FROM alpine 

ARG APPD_AGENT_VERSION 

MAINTAINER support@appdynamics.com

LABEL name="AppDynamics Agent for .Net Core on Linux" \
      vendor="AppDynamics" \
      version="${APPD_AGENT_VERSION}" \
      release="1" \
      url="https://www.appdynamics.com" \
      summary="AppDynamics solution for monitoring applications in .Net Core on Linux" \
      description="This agent monitors applications developed in.Net Core on Linux"


RUN apk update && apk upgrade && rm -f /var/cache/apk/*

COPY --from=builder /tmp /opt/appdynamics

COPY --from=builder /licenses/ /opt/appdynamics/licenses/