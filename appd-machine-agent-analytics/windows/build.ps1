[cmdletbinding()]
Param (
    [Parameter(Mandatory = $true)]
    [string]$agentVersion,

    [Parameter(Mandatory = $false)]
    [string]$dockerHubHandle,

    [Parameter(Mandatory = $false)]
    [string]$winTag
)

if ($dockerHubHandle -eq "") {
    $dockerHubHandle = "appdynamics"
 }

if ($winTag -eq "") {
    $winTag = "win-ltsc2019"
 }

$IMAGE_NAME = "$dockerHubHandle/machine-agent-analytics"

Write-Host "version = $agentVersion "
Write-Host "dockerHubHandle = $dockerHubHandle "
Write-Host "winTag = $winTag "

docker build --no-cache --build-arg APPD_AGENT_VERSION=$agentVersion -t ${IMAGE_NAME}:$agentVersion-$winTag . 
 
#./build.ps1 -agentVersion 20.6.0 -dockerHubHandle iogbole 
   
#Run it like this: 
#docker run -d --env-file env.list ${IMAGE_NAME}:$agentVersion

#docker push iogbole/machine-agent-windows-64bit:$agentVersion

#exec into into it like this: 
#docker exec -it container_id powershell 

