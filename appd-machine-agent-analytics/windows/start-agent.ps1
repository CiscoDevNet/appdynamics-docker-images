
if ([string]::IsNullOrEmpty(${env:APPDYNAMICS_MACHINE_AGENT_HOME})) {
   $MA_HOME = "c:\appdynamics\machineagent"
}else{
   $MA_HOME = "${env:APPDYNAMICS_MACHINE_AGENT_HOME}"
}

${env:APPDYNAMICS_MACHINE_AGENT_HOME}
$APPDYNAMICS_ENABLE_ANALYTICS_AGENT = ${env:APPDYNAMICS_ENABLE_ANALYTICS_AGENT}

#handle null for analytics settings 
if ([string]::IsNullOrEmpty($APPDYNAMICS_ENABLE_ANALYTICS_AGENT)) {
   $APPDYNAMICS_ENABLE_ANALYTICS_AGENT = "false"
}

if (${env:APPDYNAMICS_CONTROLLER_SSL_ENABLED} -eq "true") { 
   $APPDYNAMICS_CONTROLLER_PROTOCOL = "https"
}
else {
   $APPDYNAMICS_CONTROLLER_PROTOCOL = "http"  
}

#Splatt the env variables 
$analytics_command_args = @{
   APPDYNAMICS_AGENT_APPLICATION_NAME    = "$env:APPDYNAMICS_AGENT_APPLICATION_NAME"
   APPDYNAMICS_CONTROLLER_PROTOCOL       = "$APPDYNAMICS_CONTROLLER_PROTOCOL"
   APPDYNAMICS_CONTROLLER_HOST_NAME      = "$env:APPDYNAMICS_CONTROLLER_HOST_NAME"
   APPDYNAMICS_CONTROLLER_PORT           = "$env:APPDYNAMICS_CONTROLLER_PORT"
   EVENT_ENDPOINT                        = "$env:EVENT_ENDPOINT"
   APPDYNAMICS_AGENT_ACCOUNT_NAME        = "$env:APPDYNAMICS_AGENT_ACCOUNT_NAME"
   APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME = "$env:APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME" 
   APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY  = "$env:APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY"
   APPDYNAMICS_ENABLE_ANALYTICS_AGENT    = "$APPDYNAMICS_ENABLE_ANALYTICS_AGENT"
   APPDYNAMICS_ANALYTICS_AGENT_PORT      = "$env:APPDYNAMICS_ANALYTICS_AGENT_PORT"
   APPDYNAMICS_AGENT_PROXY_USER          = "$env:APPDYNAMICS_AGENT_PROXY_USER"
   APPDYNAMICS_AGENT_PROXY_PASS          = "$env:APPDYNAMICS_AGENT_PROXY_PASS"
   APPDYNAMICS_AGENT_PROXY_HOST          = "$env:APPDYNAMICS_AGENT_PROXY_HOST"
   APPDYNAMICS_AGENT_PROXY_PORT          = "$env:APPDYNAMICS_AGENT_PROXY_PORT"
   MACHINE_AGENT_HOME                    = "$MA_HOME"
}

if ($APPDYNAMICS_ENABLE_ANALYTICS_AGENT -eq "true") {
   if (![string]::IsNullOrEmpty(${env:APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME}) -or ![string]::IsNullOrEmpty(${env:EVENT_ENDPOINT})) {
      Write-Host "All conditions to satisfy enabling analytics agent are met...."
      $command = "c:\appdynamics\updateAnalyticsAgentConfig.ps1" 
      & $command @analytics_command_args
      
   }
   else {
      Write-Host "Analytics is desired to be enabled, but requires account name and api url to be set"
      Write-Host "APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME or EVENT_ENDPOINT is not set"
   }
}

Start-Sleep -s 2 #coz the disk io sucks 

# MA JV section begins here 

$MA_PROPERTIES += " -Dappdynamics.controller.hostName=${env:APPDYNAMICS_CONTROLLER_HOST_NAME}"
$MA_PROPERTIES += " -Dappdynamics.controller.port=${env:APPDYNAMICS_CONTROLLER_PORT}"
$MA_PROPERTIES += " -Dappdynamics.agent.accountName=${env:APPDYNAMICS_AGENT_ACCOUNT_NAME}"
$MA_PROPERTIES += " -Dappdynamics.agent.accountAccessKey=${env:APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}"
$MA_PROPERTIES += " -Dappdynamics.controller.ssl.enabled=${env:APPDYNAMICS_CONTROLLER_SSL_ENABLED}"

# SIM enabled defaults to true 
if ([string]::IsNullOrEmpty(${env:APPDYNAMICS_SIM_ENABLED})) {
   $MA_PROPERTIES += " -Dappdynamics.sim.enabled=true" 
}
else {
   $MA_PROPERTIES += " -Dappdynamics.sim.enabled=${env:APPDYNAMICS_SIM_ENABLED}" 
}

if (![string]::IsNullOrEmpty(${env:APPDYNAMICS_AGENT_UNIQUE_HOST_ID})) {
   $MA_PROPERTIES += " -Dappdynamics.agent.uniqueHostId=${env:APPDYNAMICS_AGENT_UNIQUE_HOST_ID}" 
}

if (![string]::IsNullOrEmpty(${env:APPDYNAMICS_MACHINE_HIERARCHY_PATH})) {
   $MA_PROPERTIES += " -Dappdynamics.machine.agent.hierarchyPath=${env:APPDYNAMICS_MACHINE_HIERARCHY_PATH}"
} 

if (![string]::IsNullOrEmpty(${env:APPDYNAMICS_DOTNET_COMPATIBILITY_MODE})) {
   $MA_PROPERTIES += " -Dappdynamics.machine.agent.dotnetCompatibilityMode=${env:APPDYNAMICS_DOTNET_COMPATIBILITY_MODE}" 
}
else {
   # se it to true by default 
   $MA_PROPERTIES += " -Dappdynamics.machine.agent.dotnetCompatibilityMode=true" 
}

if (![string]::IsNullOrEmpty(${env:APPDYNAMICS_AGENT_PROXY_HOST})) {
   $MA_PROPERTIES += " -Dappdynamics.http.proxyHost=${env:APPDYNAMICS_AGENT_PROXY_HOST}" 
} 

if (![string]::IsNullOrEmpty(${env:APPDYNAMICS_AGENT_HTTPS_PROXY_HOST})) {
   $MA_PROPERTIES += " -Dappdynamics.https.proxyHost=${env:APPDYNAMICS_AGENT_HTTPS_PROXY_HOST}" 
} 

if (![string]::IsNullOrEmpty(${env:APPDYNAMICS_AGENT_PROXY_PORT})) {
   $MA_PROPERTIES += " -Dappdynamics.http.proxyPort=${env:APPDYNAMICS_AGENT_PROXY_PORT}" 
} 

if (![string]::IsNullOrEmpty(${env:APPDYNAMICS_AGENT_HTTPS_PROXY_PORT})) {
   $MA_PROPERTIES += " -Dappdynamics.https.proxyPort=${env:APPDYNAMICS_AGENT_HTTPS_PROXY_PORT}" 
} 

if (![string]::IsNullOrEmpty(${env:APPDYNAMICS_AGENT_PROXY_USER})) {
   $MA_PROPERTIES += " -Dappdynamics.http.proxyUser=${env:APPDYNAMICS_AGENT_PROXY_USER}" 
} 

if (![string]::IsNullOrEmpty(${env:APPDYANMICS_AGENT_PROXY_PASSWORD_FILE})) {
   $MA_PROPERTIES += " -Dappdynamics.http.proxyPasswordFile=${env:APPDYANMICS_AGENT_PROXY_PASSWORD_FILE}" 
} 

if (![string]::IsNullOrEmpty(${env:APPDYANMICS_METRICS_MAX_LIMIT})) {
   $MA_PROPERTIES += " -Dappdynamics.agent.maxMetrics=${env:APPDYANMICS_METRICS_MAX_LIMIT}" 
} 

Write-Host  $MA_PROPERTIES

# Start Machine Agent
Start-Process $MA_HOME/jre/bin/java -ArgumentList "$MA_PROPERTIES -jar $MA_HOME/machineagent.jar" 

# this let you do 'k logs'
Start-Sleep -s 60
Get-Content -Path "$MA_HOME/logs/machine-agent.log" -Tail  10 -Wait