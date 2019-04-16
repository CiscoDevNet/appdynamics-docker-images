#!/bin/bash
#update the secret in analytics agent config
/opt/appdynamics/updateAnalyticsAgentConfig.sh $ANALYTICS_AGENT_HOME

# Start Analytics Agent
$ANALYTICS_AGENT_HOME/bin/analytics-agent.sh start