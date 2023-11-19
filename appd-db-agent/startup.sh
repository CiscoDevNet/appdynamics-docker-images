#!/bin/bash


DB_PROPERTIES=${APPDYNAMICS_DB_PROPERTIES}
DB_PROPERTIES+=" -Ddbagent.name=${APPDYNAMICS_DB_AGENT_NAME}"
DB_PROPERTIES+=" -Dappdynamics.controller.hostName=${APPDYNAMICS_CONTROLLER_HOST_NAME}"
DB_PROPERTIES+=" -Dappdynamics.controller.port=${APPDYNAMICS_CONTROLLER_PORT}"
DB_PROPERTIES+=" -Dappdynamics.agent.accountName=${APPDYNAMICS_AGENT_ACCOUNT_NAME}"
DB_PROPERTIES+=" -Dappdynamics.agent.accountAccessKey=${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}"
DB_PROPERTIES+=" -Dappdynamics.controller.ssl.enabled=${APPDYNAMICS_CONTROLLER_SSL_ENABLED}"




if [ "x${APPDYNAMICS_AGENT_PROXY_PORT}" != "x" ]; then
    DB_PROPERTIES+=" -Dappdynamics.http.proxyHost=${APPDYNAMICS_AGENT_PROXY_HOST}"
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_PORT}" != "x" ]; then
    DB_PROPERTIES+=" -Dappdynamics.http.proxyPort=${APPDYNAMICS_AGENT_PROXY_PORT}"
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_USER}" != "x" ]; then
    DB_PROPERTIES+=" -Dappdynamics.http.proxyUser=${APPDYNAMICS_AGENT_PROXY_USER}"
fi

if [ "x${APPDYNAMICS_AGENT_PROXY_PASS}" != "x" ]; then
    DB_PROPERTIES+=" -Dappdynamics.http.proxyPasswordFile=${APPDYNAMICS_AGENT_PROXY_PASS}"
fi



# Start DB Agent
java ${DB_PROPERTIES} -jar ${DB_AGENT_HOME}/db-agent.jar
