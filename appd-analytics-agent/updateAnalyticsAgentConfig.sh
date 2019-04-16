ANALYTICS_AGENT_PROPERTIES="${1}/conf/analytics-agent.properties"

replaceText () {

	sed -i "s|$1|$2|g" $3
}

PROTOCOL="http"

if [ "${APPDYNAMICS_CONTROLLER_SSL_ENABLED}" = "true" ]; then
    PROTOCOL="https"
fi

replaceText 'ad.agent.name=analytics-agent1' "ad.agent.name=analytics-${APPDYNAMICS_AGENT_APPLICATION_NAME}" $ANALYTICS_AGENT_PROPERTIES

replaceText 'ad.controller.url=http://localhost:8090' "ad.controller.url=$PROTOCOL://${APPDYNAMICS_CONTROLLER_HOST_NAME}:${APPDYNAMICS_CONTROLLER_PORT}" $ANALYTICS_AGENT_PROPERTIES

replaceText 'http.event.endpoint=http://localhost:9080' "http.event.endpoint=${APPDYNAMICS_EVENTS_API_URL}" $ANALYTICS_AGENT_PROPERTIES

replaceText 'http.event.name=customer1' "http.event.name=${APPDYNAMICS_AGENT_ACCOUNT_NAME}" $ANALYTICS_AGENT_PROPERTIES

replaceText 'http.event.accountName=analytics-customer1' "http.event.accountName=${APPDYNAMICS_GLOBAL_ACCOUNT_NAME}" $ANALYTICS_AGENT_PROPERTIES

replaceText 'http.event.accessKey=your-account-access-key' "http.event.accessKey=${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}" $ANALYTICS_AGENT_PROPERTIES

if [ "x${PROXY_HOST}" != "x" ]; then
    replaceText 'http.event.proxyHost=' "http.event.proxyHost=${APPDYNAMICS_CONTROLLER_PROXY_HOST}" $ANALYTICS_AGENT_PROPERTIES
fi

if [ "x${PROXY_PORT}" != "x" ]; then
    replaceText 'http.event.proxyPort=' "http.event.proxyPort=${APPDYNAMICS_CONTROLLER_PROXY_PORT}" $ANALYTICS_AGENT_PROPERTIES
fi
