
FROM centos:centos7

MAINTAINER AppDynamics

LABEL name="AppDynamics Network Agent" \
      vendor="AppDynamics" \
      version="4.5.11" \
      release="1" \
      url="https://www.appdynamics.com" \
      summary="AppDynamics solution for monitoring infrastructure" \
      description="The Network Agent monitors communications between applications across multiple hosts from the network point of view."

 
RUN yum update -y && yum install -y \
  iproute \
  net-tools \
  tcpdump \
  curl  \
  unzip   \
  sysvinit-tools \
  openssh-clients
 
WORKDIR /opt/appdynamics/netviz
 
ARG NETVIZ_ZIP_PKG
 
# copy NetViz agent contents
ADD ${NETVIZ_ZIP_PKG} .
 
# run the agent install script
RUN unzip *.zip && ./install.sh \
    && sed -i -e "s|enable_netlib = 1|enable_netlib = 0|g" ./conf/agent_config.lua \
    && sed -i -e "s|WEBSERVICE_IP=.*|WEBSERVICE_IP=\"0.0.0.0\"|g" ./conf/agent_config.lua
 
# default command to run for the agent
CMD  ./bin/appd-netagent -c ./conf -l ./logs -r ./run