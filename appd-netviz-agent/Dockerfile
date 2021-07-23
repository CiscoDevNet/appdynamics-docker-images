
FROM centos:centos7

ARG APPD_AGENT_VERSION

LABEL name="AppDynamics Network Agent" \
      vendor="AppDynamics" \
      version="${APPD_AGENT_VERSION}" \
      release="1" \
      url="https://www.appdynamics.com" \
      summary="AppDynamics solution for monitoring infrastructure" \
      description="The Network Agent monitors communications between applications across multiple hosts from the network point of view."

 
RUN yum update -y && yum install -y \
  iproute \
  net-tools \
  tcpdump \
  curl  \
  bind-utils \
  unzip   \
  sysvinit-tools \
  openssh-clients && rm -rf /var/cache/yum && yum clean all
 
WORKDIR /opt/appdynamics/netviz
 
COPY LICENSE .
# copy NetViz agent contents
COPY appd-netviz-${APPD_AGENT_VERSION}.zip .
RUN if [ "x${APPD_AGENT_SHA256}" != "x" ]; then \ 
 echo "${APPD_AGENT_SHA256} *appd-netviz-${APPD_AGENT_VERSION}.zip" >> appd_checksum \
    && sha256sum -c appd_checksum \
    && rm appd_checksum \
    && unzip -oq appd-netviz-${APPD_AGENT_VERSION}.zip; \
   else \
     unzip -oq appd-netviz-${APPD_AGENT_VERSION}.zip; \
   fi
# run the agent install script
RUN ./install.sh \
    && sed -i -e "s|enable_netlib = 1|enable_netlib = 0|g" ./conf/agent_config.lua \
    && sed -i -e "s|WEBSERVICE_IP=.*|WEBSERVICE_IP=\"0.0.0.0\"|g" ./conf/agent_config.lua
# cleanup
RUN rm -f appd-netviz-${APPD_AGENT_VERSION}.zip 
# default command to run for the agent
CMD  ./bin/appd-netagent -c ./conf -l ./logs -r ./run