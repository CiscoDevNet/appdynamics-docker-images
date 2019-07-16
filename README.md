# AppDynamics Official Docker Images

Official AppDynamics docker images for our APM and Server Agents.  These images are available from the Docker Store and can be downloaded using `docker pull`; see below for the image names and tags that can be downloaded.  We currently provide images that have the Java Agent pre-installed, using certified base images for OpenJDK, Tomcat and Jetty. Additional images that include APM Agents for other language runtimes will be available shortly.  We also provide an official image for our Server Agent, pre-configured to run our Integrated Docker Visibility monitoring. Please see the [documentation](https://docs.appdynamics.com/) for more information about AppDynamics [Java APM](https://docs.appdynamics.com/display/PRO45/Application+Monitoring) and [Server Visibility](https://docs.appdynamics.com/display/PRO45/Server+Visibility) monitoring.

To use the images, you need either an on-premise installation of AppDynamics or an AppDynamics SaaS account: please visit [AppDynamics.com](https://www.appdynamics.com/) for details.

## Java APM Agent

### How to build the Java APM Agent Images

To build the Java Agent images, you will need to supply:

1. The installer for the Java Agent - Sun and JRockit JVM
2. The SHA256 checksum to verify the image

These can both be obtained from the [AppDynamics Download Site](https://download.appdynamics.com)

Set the following environment variables - these will be passed automatically to `docker-compose` at build time :

* `APPD_AGENT_VERSION`: the 4-digit version string
* `APPD_AGENT_SHA256`: the SHA256 checksum for the installer

Change directory to the appd-java folder and run `docker-compose build`

This will build the following images:

***Tomcat-based Images***

* `appdynamics/java:<VERSION>_tomcat7-jre7-alpine`
* `appdynamics/java:<VERSION>_tomcat7-jre8-alpine`
* `appdynamics/java:<VERSION>_tomcat8-jre7-alpine`
* `appdynamics/java:<VERSION>_tomcat8-jre8-alpine`
* `appdynamics/java:<VERSION>_tomcat9-jre8-alpine`
* `appdynamics/java:<VERSION>_tomcat7-jre8`
* `appdynamics/java:<VERSION>_tomcat8-jre8`
* `appdynamics/java:<VERSION>_tomcat9-jre8`

***Jetty-based Images***

* `appdynamics/java:<VERSION>_jetty9-jre8-alpine`
* `appdynamics/java:<VERSION>_jetty9-jre8`

***OpenJDK-based Images***

* `appdynamics/java:<VERSION>_jre9-slim`
* `appdynamics/java:<VERSION>_jdk7-alpine`
* `appdynamics/java:<VERSION>_jdk8-alpine`
* `appdynamics/java:<VERSION>_jdk8-slim`
* `appdynamics/java:<VERSION>_jre8-slim`
* `appdynamics/java:<VERSION>_jre7-alpine`
* `appdynamics/java:<VERSION>_jdk7-slim`
* `appdynamics/java:<VERSION>_jre8-alpine`
* `appdynamics/java:<VERSION>_jre7-slim`

### How to run the Java APM Agent Images

***Tomcat and Jetty-based images***

The agent is initialized using AppDynamics node environment variables as described in the product [documentation](https://docs.appdynamics.com/display/PRO45/Use+Environment+Variables+for+Java+Agent+Settings).  These can be passed to the container at run-time using environment variables (`-e` or `--env`) or env-file (`--env-file`): there is an example env-file (`appdynamics.env`) included with this repo that gives the environment variables that must be set in order for the agent to connect to the AppDynamics Controller.

If setting a fixed node name is desired, you can set one with the `APPDYNAMICS_AGENT_NODE_NAME` environment variable, however please note that node names need to be unique within an AppDynamics tier so this approach will not work for scale-out scenarios.  

For scale-out scenarios, the presence of the `APPDYNAMICS_NODE_PREFIX` variable causes the start scripts within the docker images to request dynamic node naming (see "Dynamic Node Naming" in the [documentation](https://docs.appdynamics.com/display/PRO45/Java+Agent+Configuration+Properties) for more details about this option.  If you set both `APPDYNAMICS_AGENT_NODE_NAME` and `APPDYNAMICS_NODE_PREFIX` then the agent will name the node according to the dynamic naming rules, but the agent log directory within the container will be named per the `APPDYNAMICS_AGENT_NODE_NAME` variable.

For both the Tomcat and Jetty-based images, the app server will start automatically and the AppDynamics agent will connect to the Controller, provided that the correct connection parameters are passed to the container, as described above.  The images can be extended to include the application archives, or these can be copied to a running container using `docker cp`. Please see the [Tomcat](https://store.docker.com/images/tomcat) and [Jetty](https://store.docker.com/images/jetty) documentation on the Docker store for details of those base images.

***OpenJDK-based Images***

These images are provided for you to customize your own container builds.  They use OpenJDK base images (JRE and JDK variants are provided), with the AppDynamics Java Agent pre-installed in the /opt/appdynamics folder. Please see the [OpenJDK](https://store.docker.com/images/openjdk) documentation on the Docker Store for details of the base image. With these images, it is up to you how to configure the AppDynamics Agent: you can use the AppDynamics node environment variables as described in the product [documentation](https://docs.appdynamics.com/display/PRO45/Use+Environment+Variables+for+Java+Agent+Settings).  See above for information on how to pass environment variables to the container at runtime.

## Server Agent

### How to build the Server Agent Image

To build the Server Agent image, you will need to supply:

1. The installer for the Machine Agent (zip version - no JRE)
2. The SHA256 checksum to verify the image

These can both be obtained from the [AppDynamics Download Site](https://download.appdynamics.com)

Set the following environment variables - these will be passed automatically to `docker-compose` at build time :

* `APPD_AGENT_VERSION`: the 4-digit version string
* `APPD_AGENT_SHA256`: the SHA256 checksum for the installer

Change directory to the appd-machine folder and run `docker-compose build`

This will build the following images:

* `appdynamics/machine:<VERSION>`

### How to run the Server Agent Image

The agent is initialized using machine agent environment variables as described in the product [documentation](https://docs.appdynamics.com/display/PRO45/Standalone+Machine+Agent+Configuration+Properties).  These can be passed to the container at run-time using environment variables (`-e` or `--env`) or env-file (`--env-file`): note that you do not need to pass either a node or tier name to run the Server Agent with Integrated Docker Visibility.

The `MACHINE_AGENT_PROPERTIES` environment variable can be set to pass additional values to the machine agent at startup.  This allows you to run the container in three different ways:

1. Standalone Machine Agent
2. Server Agent (SIM-enabled)
3. Server Agent (SIM-enabled) with Integrated Docker Visibility

To enable Integrated Docker Visibility, you must run the container with two volume mounts that provide access to the host file system (read-only) and the UNIX domain socket for the Docker Engine API.  In addition, the following property must be set:

`MACHINE_AGENT_PROPERTIES=-Dappdynamics.sim.enabled=true -Dappdynamics.docker.enabled=true`

The example env-file (`appdynamics.env`) included in the *appd-machine* folder gives the environment variables that must be set in order for the agent to connect to the AppDynamics Controller.  

The following example shows how to run the Server Agent container with Integrated Docker Visibility using environment variables:

```
docker login -u="$DOCKER_USERNAME" && \
docker run -d \
-e APPDYNAMICS_CONTROLLER_HOST_NAME=<controller-host-name> \
-e APPDYNAMICS_CONTROLLER_PORT=<controller-port> \
-e APPDYNAMICS_CONTROLLER_SSL_ENABLED=<true-or-false> \
-e APPDYNAMICS_AGENT_ACCOUNT_NAME=<account-name> \
-e APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=<account-access-key> \
-e MACHINE_AGENT_PROPERTIES="-Dappdynamics.sim.enabled=true -Dappdynamics.docker.enabled=true" \
-v /proc:/hostroot/proc:ro -v /sys:/hostroot/sys:ro -v /etc:/hostroot/etc:ro -v /var/run/docker.sock:/var/run/docker.sock \
store/appdynamics/machine:<VERSION>
```
