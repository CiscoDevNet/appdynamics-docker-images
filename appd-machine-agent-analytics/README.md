## Machine Agent

### Pre-built images
The prebuilt images are available from the Docker Hub.

`appdynamics/machine-agent-analytics:latest` or

`appdynamics/machine-agent-analytics:4.5.9` to get a specific version of the agent

### Build your own image

* Download the latest agent bundle from the [AppDynamics Official Download Site](https://download.appdynamics.com/download/) 
* Make a note of sha256 checksum value for the download
* Rename the file to MachineAgent-x.x.x, substituing `x` with the version number, e.g. `MachineAgent-4.5.10.zip`
* Run ./build.sh passing the version, as it appears in the name of the zip file, and the checksum:
`./build.sh 4.5.10 d472dfc75469c`
 
 The checksum can be left blank to avoid validation. 
It is a best practice to validate the package integrity.

By default the image is tagged `appdynamics/machine-agent-analytics`. To change the image tag, pass the new name as the 3rd parameter to the build.sh:
`./build.sh 4.5.10 d472dfc75469c `

### Deploy the AppDynamics MachineAgent

* Create namespace for the AppDynamics MachineAgent. In this example, it is called `appdynamics`

``` 
$ kubectl create ns appdynamics
```

```
# in OpenShift
$ oc new-project appdynamics 
```

* Create a secret to hold the AppDynamics controller access key

```
kubectl -n appdynamics create secret generic appd-secret \
--from-literal=appd-key=<controller-access-key>
```

* Populate the configMap in ma-config.yaml with values specific to your environment. The following values are required:
*
* Create the configMap
```
kubectl create -f deploy/ma-config.yaml
```

Deploy the configMap with logging settings
```
kubectl create -f deploy/ma-log-config.yaml
```

* Create a service account with appropriate RBAC permissions. By default, the account name is `appdynamics-infraviz`.
The account needs to be privileged and have a read-only access to cluster entities

```
$ kubectl create -f deploy/rbac.yaml
```

```
# For OpenShift
$ oc create -f deploy/rbac-openshift.yaml
```

* Update the spec machine-agent.yaml with the reference to the newly built image. By default, the image name is set to:
`appdynamics/machine-agent-analytics`

* deploy the daemon set

```
$ kubectl create -f deploy/machine-agent.yaml

```

```
# on PKS run:
$ kubectl create -f deploy/machine-agent-pks.yaml
```

