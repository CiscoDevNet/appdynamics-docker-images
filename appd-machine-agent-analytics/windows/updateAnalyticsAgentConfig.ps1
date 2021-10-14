[CmdletBinding()]
param(
    
    [Parameter(Mandatory = $false)]
    [string]$APPDYNAMICS_AGENT_APPLICATION_NAME,

    [Parameter(Mandatory = $false)]
    [ValidateSet("true", "false")]
    [string]$APPDYNAMICS_ENABLE_ANALYTICS_AGENT,

    [Parameter(Mandatory = $false)]
    [string]$APPDYNAMICS_ANALYTICS_AGENT_PORT,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$MACHINE_AGENT_HOME,
 
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$APPDYNAMICS_CONTROLLER_PROTOCOL,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$APPDYNAMICS_CONTROLLER_HOST_NAME,
    
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$APPDYNAMICS_CONTROLLER_PORT,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$EVENT_ENDPOINT,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$APPDYNAMICS_AGENT_ACCOUNT_NAME,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME,

    [Parameter(Mandatory = $false)]
    [string]$APPDYNAMICS_AGENT_PROXY_HOST,
    
    [Parameter(Mandatory = $false)]
    [string]$APPDYNAMICS_AGENT_PROXY_PORT,

    [Parameter(Mandatory = $false)]
    [string]$APPDYNAMICS_AGENT_PROXY_USER,

    [Parameter(Mandatory = $false)]
    [string]$APPDYNAMICS_AGENT_PROXY_PASS
)

if ((![string]::IsNullOrEmpty($APPDYNAMICS_ENABLE_ANALYTICS_AGENT)) -and $APPDYNAMICS_ENABLE_ANALYTICS_AGENT -eq "false") {
    $APPDYNAMICS_ENABLE_ANALYTICS_AGENT = "false"
}
else {
    # Enable analytics by default if the customer doesn't explicitly set it to false 
    $APPDYNAMICS_ENABLE_ANALYTICS_AGENT = "true"
}

$enable_analytics_regex = "<enabled>(?:tru|fals)e.*>$"
$enable_analytics = "<enabled>$APPDYNAMICS_ENABLE_ANALYTICS_AGENT</enabled>"
$monitorXML = "$MACHINE_AGENT_HOME\monitors\analytics-agent\monitor.xml"

(Get-Content $monitorXML) | ForEach-Object { $_ -replace "$enable_analytics_regex" , "$enable_analytics" } | Set-Content $monitorXML

$SOURCE_FILE = "$MACHINE_AGENT_HOME\monitors\analytics-agent\conf\analytics-agent.properties"

$destinationFile = $SOURCE_FILE

Copy-Item $SOURCE_FILE $SOURCE_FILE'.backup'

$controller_url = -join ($APPDYNAMICS_CONTROLLER_PROTOCOL, "://", $APPDYNAMICS_CONTROLLER_HOST_NAME, ":", $APPDYNAMICS_CONTROLLER_PORT).Replace(' ', '')

if ([string]::IsNullOrEmpty($APPDYNAMICS_AGENT_APPLICATION_NAME)) {
    $APPDYNAMICS_AGENT_APPLICATION_NAME = "analytics-agent"
}
$agent_name_new = -join ($APPDYNAMICS_AGENT_APPLICATION_NAME, "_", $env:computername).Replace(' ', '')

(Get-Content $SOURCE_FILE) | ForEach-Object {
    $_ -replace "ad.agent.name=analytics-agent1", "ad.agent.name=$agent_name_new" `
        -replace "http.event.accessKey=your-account-access-key", "http.event.accessKey=$APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY" `
        -replace "ad.controller.url=http://localhost:8090", "ad.controller.url=$controller_url" `
        -replace "http.event.endpoint=http://localhost:9080", "http.event.endpoint=$EVENT_ENDPOINT" `
        -replace "http.event.name=customer1", "http.event.name=$APPDYNAMICS_AGENT_ACCOUNT_NAME" `
        -replace "http.event.accountName=analytics-customer1", "http.event.accountName=$APPDYNAMICS_AGENT_GLOBAL_ACCOUNT_NAME" 
} | Set-Content $destinationFile

if ((![string]::IsNullOrEmpty($APPDYNAMICS_AGENT_PROXY_HOST)) -and  (![string]::IsNullOrEmpty($APPDYNAMICS_AGENT_PROXY_PORT))) {
    (Get-Content $SOURCE_FILE) | ForEach-Object {
        $_ -replace "http.event.proxyHost=", "http.event.proxyHost=$APPDYNAMICS_AGENT_PROXY_HOST"
        -replace "http.event.proxyPort=", "http.event.proxyPort=$APPDYNAMICS_AGENT_PROXY_PORT"
    } | Set-Content $destinationFile    
} 

if (![string]::IsNullOrEmpty($APPDYNAMICS_ANALYTICS_AGENT_PORT)) {
    (Get-Content $SOURCE_FILE) | ForEach-Object {
        $_ -replace "ad.dw.http.port=9090", "ad.dw.http.port=$APPDYNAMICS_ANALYTICS_AGENT_PORT"
    } | Set-Content $destinationFile    
} 

if (![string]::IsNullOrEmpty($APPDYNAMICS_AGENT_PROXY_USER)) {
    (Get-Content $SOURCE_FILE) | ForEach-Object {
        $_ -replace "http.event.proxyUsername=", "http.event.proxyUsername==$APPDYNAMICS_AGENT_PROXY_USER"
    } | Set-Content $destinationFile
} 

if (![string]::IsNullOrEmpty($APPDYNAMICS_AGENT_PROXY_PASS)) {
    (Get-Content $SOURCE_FILE) | ForEach-Object {
        $_ -replace "http.event.proxyPassword=", "http.event.proxyPassword=$APPDYNAMICS_AGENT_PROXY_PASS"
    } | Set-Content $destinationFile
} 