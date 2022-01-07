#!/bin/bash
AGENT_VER="21.9.0.4385"
if [ "x${APPDYNAMICS_AGENT_VERSION}" = "x" ]; then
    echo "APPDYNAMICS_AGENT_VERSION not set; defaulting to ${AGENT_VER}"
else
    echo "Using agent version ${APPDYNAMICS_AGENT_VERSION}"
    AGENT_VER=${APPDYNAMICS_AGENT_VERSION}
fi

if [ "x${APP_ENTRY_POINT}" = "x" ]; then
	echo  "APP_ENTRY_POINT variable must be set. Aborting..."
	exit 1
fi

pip install -U appdynamics==${AGENT_VER}

pyagent run --use-manual-proxy $APP_ENTRY_POINT