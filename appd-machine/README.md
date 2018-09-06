# Building Docker with Machine Agent

## Pre-Requisites

- Docker installed.
- Download [Machine Agent](https://download.appdynamics.com/download/#version=&apm=machine&os=linux)


## Steps


- Download StandAlone Machine agent from [AppDynamics Download Portal](https://download.appdynamics.com/download/#version=&apm=machine&os=linux) into the current directory. 

```
(master)$ ls
Dockerfile			README.md			docker-compose.yml
MachineAgent-4.5.1.1385.zip	appdynamics.env			env

```

- If you have any extensions, Unzip the machine agent and copy the extension into `monitor` directory and zip it back.

```
(master)$ mkdir tmp

(master)$ unzip MachineAgent-4.5.1.1385.zip -d tmp/

(master)$ unzip Downloads/PCFFirehoseMonitor-1.0.0.10.zip -d tmp/monitors/

(master)$ cd tmp

(master)$ zip -r ../MachineAgent-4.5.1.1385.zip  *

```


- set the environment variable 
  -  `APPD_AGENT_MAJOR_VERSION` to some string 
  -  `APPD_AGENT_VERSION` to the version of machine agent 
  -  `APPD_AGENT_SHA256` to sha256 of the newly packaged MachineAgent zip file.
  
```
(master)$ export APPD_AGENT_MAJOR_VERSION=local

(master)$ export APPD_AGENT_VERSION=4.5.1.1385

(master)$ shasum -a 256 MachineAgent-4.5.1.1385.zip 
2a511b3e0051e8d4bd958e6bf053d426698393fd8df00ed867dd49c27cdcf2b3  MachineAgent-4.5.1.1385.zip

(master)$ export APPD_AGENT_SHA256=2a511b3e0051e8d4bd958e6bf053d426698393fd8df00ed867dd49c27cdcf2b3

```

- Build the image by doing `docker-compose build`

```
(master)$ docker-compose build

....
Removing intermediate container a3a73c8622c8
 ---> 30beb29611f7
Successfully built 30beb29611f7
Successfully tagged appdynamics/machine:local

```


## Running the container

- Fill in the [controller configuration](https://docs.appdynamics.com/display/PRO45/Standalone+Machine+Agent+Configuration+Properties) in the file `env`

You may include any other AppDynamics configuration environment variables you wish to include.  


```
$ vim env 

APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=acesssKey
APPDYNAMICS_AGENT_ACCOUNT_NAME=customer1
APPDYNAMICS_CONTROLLER_HOST_NAME=controller.e2e.appd-test.com
APPDYNAMICS_CONTROLLER_PORT=8090
APPDYNAMICS_AGENT_APPLICATION_NAME=app
APPDYNAMICS_AGENT_NODE_NAME=node
APPDYNAMICS_AGENT_TIER_NAME=tier

```



- Just do a `docker run`

```
$ docker run --env-file env  appdynamics/machine:local 

Using Java Version [1.8.0_181] for Agent
Using Agent Version [Machine Agent v4.5.1.1385 GA Build Date 2018-07-25 17:57:44]
[INFO] Agent logging directory set to: [/opt/appdynamics]

```
