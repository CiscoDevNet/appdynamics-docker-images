### Machine agent deployment

* Download the latest agent bundle from https://download.appdynamics.com/download/
* Make a note of sha256 checksum value and the full version of the agent (e.g. 4.5.9.2096)
* Run ./build.sh passing the version and the checksum. The checksum can be left blank to avoid validation. 
It is a best practice to validate the package integrity.


* Create a secret to hold appdynamics controller access key
```
kubectl create secret generic appd-secret --from-literal=appd-key=<controller-access-key>
```

* Populate the configMap in ma-config.yaml with values specific to your environment. Make sure you provide all the required values.

* Create the configMap
```
kubectl create -f deploy/ma-config.yaml
```

Deploy the configMap with logging settings
```
kubectl create -f deploy/ma-log-config.yaml
```


* Update the spec machine-agent.yaml with the reference to the newly built image. By default the image name is
appdynamics/machine-agent-analytics

* Create a service account for deployment. By default it is `appd-infra-sa`.
The account needs to be privileged and have a read-only access to cluster entities

* deploy the daemon set
```
kubectl create -f deploy/machine-agent.yaml
```


## Service account in OpenShift

* create a new project or use an existing one
```
oc new-project appdynamics
```

 * create a service account for the daemon set deployment
```
oc create sa appd-infra-sa
```

* make the account privileged, which is necessary for accessing docker api and host root
oc adm policy add-scc-to-user privileged -z appd-infra-sa

* assign account to the cluster-reader role to be able to read pod metadata
```
oc adm policy add-cluster-role-to-user cluster-reader -z appd-infra-sa
```


