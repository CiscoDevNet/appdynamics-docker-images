FROM openjdk:8-jre-slim AS builder

MAINTAINER mark.prichard@appdynamics.com

ARG APPD_AGENT_VERSION 
ARG APPD_AGENT_SHA256

COPY MachineAgent-${APPD_AGENT_VERSION}.zip /
RUN echo "${APPD_AGENT_SHA256} *MachineAgent-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && unzip -oq MachineAgent-${APPD_AGENT_VERSION}.zip -d /tmp 


FROM openjdk:8-jre-slim
RUN apt-get update && apt-get -y upgrade
COPY --from=builder /tmp /opt/appdynamics

CMD ["sh", "-c", "java ${MACHINE_AGENT_PROPERTIES} -jar /opt/appdynamics/machineagent.jar"]
