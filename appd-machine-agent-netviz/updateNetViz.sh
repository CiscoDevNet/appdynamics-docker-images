NETVIZ_AGENT_PROPERTIES="${1}/extensions/NetVizExtension/conf/netVizExtensionConf.yml"

replaceText () {

	sed -i "s|$1|$2|g" $3
}




replaceText 'start: false' "start: true" $NETVIZ_AGENT_PROPERTIES


