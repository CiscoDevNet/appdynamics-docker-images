FROM openjdk:8u151-jre-alpine3.7 AS builder

ARG APPD_AGENT_VERSION
ARG APPD_AGENT_SHA256

COPY MachineAgent-${APPD_AGENT_VERSION}.zip /
RUN echo "${APPD_AGENT_SHA256} *MachineAgent-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && mkdir /tmp/unzip \
    && unzip -oq MachineAgent-${APPD_AGENT_VERSION}.zip -d /tmp/unzip


FROM openjdk:8u151-jre-alpine3.7
RUN apk add --no-cache iproute2 procps sysstat dumb-init bash coreutils
COPY --from=builder /tmp/unzip /opt/appdynamics

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["sh", "-c", "java ${MACHINE_AGENT_PROPERTIES} -jar /opt/appdynamics/machineagent.jar"]
