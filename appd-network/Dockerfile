FROM ubuntu:14.04

ARG NETVIZ_ZIP_PKG

RUN apt-get update && apt-get install -y \
  net-tools \
  tcpdump \
  curl  \
  unzip   \
  ssh-client \
  binutils \
  build-essential \
  vim

WORKDIR /netviz-agent

# copy NetViz agent contents
COPY $NETVIZ_ZIP_PKG .

# run the agent install script
RUN unzip $NETVIZ_ZIP_PKG && ./install.sh

# default command to run for the agent
CMD  ./bin/appd-netagent -c ./conf -l ./logs -r ./run
