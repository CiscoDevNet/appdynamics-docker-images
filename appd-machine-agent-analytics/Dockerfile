
FROM openjdk:8-jre-slim AS builder

MAINTAINER support@appdynamics.com

LABEL name="AppDynamics MachineAgent" \
      vendor="AppDynamics" \
      version="4.5.16" \
      release="1" \
      url="https://www.appdynamics.com" \
      summary="AppDynamics solution for monitoring infrastructure" \
      description="The MachineAgent monitors resource utilization, server load and process on the host."

ARG APPD_AGENT_VERSION 
ARG APPD_AGENT_SHA256

RUN apt-get update -y; \
 apt-get install -y unzip

COPY MachineAgent-${APPD_AGENT_VERSION}.zip /
RUN if [ "x${APPD_AGENT_SHA256}" != "x" ]; then \ 
	echo "${APPD_AGENT_SHA256} *MachineAgent-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && unzip -oq MachineAgent-${APPD_AGENT_VERSION}.zip -d /tmp; \
    else \
     unzip -oq MachineAgent-${APPD_AGENT_VERSION}.zip -d /tmp; \
    fi

ADD LICENSE /licenses/

FROM openjdk:8-jre-slim
RUN apt-get update -y; \
 apt-get install -y --no-install-recommends iproute2 procps sysstat dumb-init bash coreutils sed; \
	rm -rf /var/lib/apt/lists/*

RUN groupadd appdynamics && \
    useradd appdynamics -g appdynamics 

COPY --from=builder /tmp /opt/appdynamics
COPY --from=builder /licenses /licenses

ENV MACHINE_AGENT_HOME /opt/appdynamics

WORKDIR ${MACHINE_AGENT_HOME}

COPY updateAnalyticsAgent.sh ./updateAnalyticsAgent.sh
RUN chmod +x ./updateAnalyticsAgent.sh

COPY startup.sh ./startup.sh
RUN chmod +x ./startup.sh

RUN chown -R appdynamics:appdynamics /opt/appdynamics && chmod 744 ${MACHINE_AGENT_HOME}

RUN chgrp -R 0 /opt/appdynamics && chmod -R g+w /opt/appdynamics

USER appdynamics

EXPOSE 9090

CMD "./startup.sh"