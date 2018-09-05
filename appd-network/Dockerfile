FROM centos:centos7

MAINTAINER mark.prichard@appdynamics.com

ARG APPD_AGENT_VERSION 
ARG APPD_AGENT_SHA256
ARG

COPY appd-netviz-x64-linux-${APPD_AGENT_VERSION}.rpm /
RUN echo "${APPD_AGENT_SHA256} *appd-netviz-x64-linux-${APPD_AGENT_VERSION}.rpm" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && rpm -ivh appd-netviz-x64-linux-${APPD_AGENT_VERSION}.rpm

FROM centos:centos7
COPY --from=builder /tmp /opt/appdynamics
RUN service appd-netviz start
CMD ["sh", "-c", "java ${MACHINE_AGENT_PROPERTIES} -jar /opt/appdynamics/machineagent.jar"]
