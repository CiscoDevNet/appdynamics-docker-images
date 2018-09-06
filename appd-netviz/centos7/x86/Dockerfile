FROM centos:centos7

MAINTAINER mark.prichard@appdynamics.com

ARG APPD_AGENT_VERSION 
ARG APPD_AGENT_SHA256

COPY appd-netviz-x64-linux-${APPD_AGENT_VERSION}.rpm /
COPY start.sh /
RUN echo "${APPD_AGENT_SHA256} *appd-netviz-x64-linux-${APPD_AGENT_VERSION}.rpm" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && yum install -y initscripts \ 
    && rpm -ivh appd-netviz-x64-linux-${APPD_AGENT_VERSION}.rpm

CMD ["./start.sh"]
