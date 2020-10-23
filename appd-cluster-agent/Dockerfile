# Make sure that the cluster agent image has the same environment on which it was built on because the
# binary is dependent on the os and architecture on which it was built.
ARG version=latest
FROM alpine:$version

MAINTAINER AppDynamics

LABEL name="AppDynamics Cluster Agent" \
      vendor="AppDynamics" \
      version="20.10.0" \
      release="1" \
      url="https://www.appdynamics.com" \
      summary="AppDynamics monitoring solution for applications deployed to Kubernetes clusters" \
      description="The ClusterAgent monitors state of Kubernetes or openshift resources and derives metrics to provide visibility into common application impacting issues."

# Install required packages
RUN apk --update add --no-cache unzip ca-certificates && update-ca-certificates

# Install AppDynamics Cluster Agent
ENV CLUSTER_AGENT_HOME /opt/appdynamics/cluster-agent/
COPY cluster-agent.zip /tmp/cluster-agent.zip
COPY LICENSE /licenses/

# Create a group and user
RUN addgroup -S -g 1001 appdynamics && \
    adduser -S -s /bin/sh -G appdynamics -u 1001 appdynamics && \
    mkdir -p ${CLUSTER_AGENT_HOME} && \
    unzip -oq /tmp/cluster-agent.zip -d ${CLUSTER_AGENT_HOME} && \
    rm /tmp/cluster-agent.zip && \
    rm -rf /opt/appdynamics/cluster-agent/config/agent-monitoring.yml && \
    rm -rf /opt/appdynamics/cluster-agent/config/instrumentation.yml && \
    mkdir /opt/appdynamics/cluster-agent/config/agent-monitoring && \
    touch /opt/appdynamics/cluster-agent/config/agent-monitoring/agent-monitoring.yml && \
    ln -s /opt/appdynamics/cluster-agent/config/agent-monitoring/agent-monitoring.yml /opt/appdynamics/cluster-agent/config/agent-monitoring.yml && \
    mkdir /opt/appdynamics/cluster-agent/config/instrumentation && \
    touch /opt/appdynamics/cluster-agent/config/instrumentation/instrumentation.yml && \
    ln -s /opt/appdynamics/cluster-agent/config/instrumentation/instrumentation.yml /opt/appdynamics/cluster-agent/config/instrumentation.yml

# Include start script to configure and start Cluster Agent at runtime
COPY start-appdynamics ${CLUSTER_AGENT_HOME}
RUN mkdir -p ${CLUSTER_AGENT_HOME}/logs && chmod 774 ${CLUSTER_AGENT_HOME}/logs && \
    chmod 744 ${CLUSTER_AGENT_HOME}/start-appdynamics && \
    chown -R appdynamics:0 /opt/appdynamics && \
    chmod -R 774 /opt/appdynamics

USER 1001

# Changing directory to CLUSTER_AGENT_HOME
WORKDIR ${CLUSTER_AGENT_HOME}

# Decided system shell an ENTRYPOINT because to run command to debug the container whenever required
# execute the start-appdynamics.sh script in the shell and start the cluster agent
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "./start-appdynamics"]

