# Set AppDynamics Java Agent environment variables using docker run -e, --env or --env-file
# https://docs.appdynamics.com/display/PRO43/Use+Environment+Variables+for+Java+Agent+Settings
export CATALINA_OPTS="$CATALINA_OPTS -javaagent:/opt/appdynamics/javaagent.jar ${APPDYNAMICS_NODE_PREFIX:+-Dappdynamics.agent.reuse.nodeName=true -Dappdynamics.agent.reuse.nodeName.prefix=${APPDYNAMICS_NODE_PREFIX}}"
