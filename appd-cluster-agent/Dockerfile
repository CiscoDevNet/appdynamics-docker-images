# Make sure that the cluster agent image has the same environment on which it was built on because the
# binary is dependent on the os and architecture on which it was built.
FROM alpine:3.9

# Install required packages
RUN apk --update add --no-cache unzip ca-certificates && update-ca-certificates

# Install AppDynamics Cluster Agent
ENV CLUSTER_AGENT_HOME /opt/appdynamics/cluster-agent/
ADD cluster-agent.zip /tmp/cluster-agent.zip

# Create a group and user
RUN addgroup -S appdynamics && \
    adduser -S -s /bin/sh -G appdynamics appdynamics && \
    mkdir -p ${CLUSTER_AGENT_HOME} && \
    unzip -oq /tmp/cluster-agent.zip -d ${CLUSTER_AGENT_HOME} && \
    rm /tmp/cluster-agent.zip && \
    rm -rf /opt/appdynamics/cluster-agent/config/agent-monitoring.yml && \
    mkdir /opt/appdynamics/cluster-agent/config/agent-monitoring && \
    touch /opt/appdynamics/cluster-agent/config/agent-monitoring/agent-monitoring.yml && \
    ln -s /opt/appdynamics/cluster-agent/config/agent-monitoring/agent-monitoring.yml /opt/appdynamics/cluster-agent/config/agent-monitoring.yml

# Include start script to configure and start Cluster Agent at runtime
ADD start-appdynamics ${CLUSTER_AGENT_HOME}
RUN mkdir -p ${CLUSTER_AGENT_HOME}/logs && chmod 774 ${CLUSTER_AGENT_HOME}/logs && \
    chmod 744 ${CLUSTER_AGENT_HOME}/start-appdynamics && \
    chown -R appdynamics:appdynamics /opt/appdynamics

USER appdynamics

# Changing directory to CLUSTER_AGENT_HOME
WORKDIR ${CLUSTER_AGENT_HOME}

# Decided to make this an ENTRYPOINT instead of CMD because the cluster agent should be executed once docker run is
# invoked.
ENTRYPOINT ["./start-appdynamics"]
