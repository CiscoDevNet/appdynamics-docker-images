FROM openjdk:11-jre-slim AS builder

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

FROM openjdk:11-jre-slim

ARG APPD_AGENT_VERSION

LABEL name="AppDynamics MachineAgent" \
      vendor="AppDynamics" \
      version="${APPD_AGENT_VERSION}" \
      release="1" \
      url="https://www.appdynamics.com" \
      summary="AppDynamics solution for monitoring infrastructure" \
      description="The MachineAgent monitors resource utilization, server load and processes on the host."

FROM openjdk:11-jre-slim 

RUN apt-get update && apt-get -y upgrade && \
apt-get install -y \
apt-utils \
bash \
bc \
coreutils \
dnsutils \
dumb-init \
gawk \
grep \
iproute2 \
procps \
sed \
sysstat \
unzip \
&& rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY --from=builder /tmp /opt/appdynamics

ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["sh", "-c", "java ${MACHINE_AGENT_PROPERTIES} -jar /opt/appdynamics/machineagent.jar"]
