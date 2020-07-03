To build the cluster agent Image to deploy it on K8s or Openshift. Please follow the below steps:

1. Get the cluster agent packages from Appdynamics Download Portal (https://download.appdynamics.com/). 
The available packages on download portal are:

    a) One based on Alpine Linux version 3.11.6 (appdynamics-cluster-agent-alpine-linux-<Agent-version>.zip) 
    
    b) One based on Rhel Linux version 7 (appdynamics-cluster-agent-rhel-linux-<Agent-version>.zip)
    
    Download the above package according to the Image type you want to build. 
    If you want to build Alpine based cluster agent Image then download appdynamics-cluster-agent-alpine-linux-<Agent-version>.zip file and if you want to build Rhel based cluster agent Image then download appdynamics-cluster-agent-rhel-linux-<Agent-version>.zip.

2. Now Extract the zip file which you have downloaded from Appdynamics Download Portal. Then open the extracted file and go to the docker folder and get the cluster-agent.zip file.

3. Copy the cluster-agent.zip file to the folder where you have cloned the appd-cluster-agent repo. Make sure that now you have below files before going to the next step.

    a) Dockerfile
    
    b) Dockerfile-rhel
    
    c) start-appdynamics 
    
    d) cluster-agent.zip 

4. Build and tag a docker image using this syntax:

    a) For Alpine Linux 3.11.6

        docker build -t <registryname>/<accountname>/cluster-agent:<Agent-version> .
        
      For Example:
      
        docker build -t docker.io/johndoe/cluster-agent:20.6.0 .
         
    b) For Rhel Linux 7
    
        docker build -t <registryname>/<accountname>/cluster-agent:<Agent-version> -f Dockerfile-rhel .
          
      For Example:
     
        docker build -t docker.io/johndoe/cluster-agent:20.6.0 -f Dockerfile-rhel .
 
5. When the build is successful, check that the image appears in your local Docker repository.

6. Now, you are able to use the cluster agent Image.

7. You can also push the Image to your local docker Hub or Redhat container registry. 

**NOTE**: You can also use a pre-built Alpine based Cluster Agent Image or Rhel based Cluster Agent Image. Please refer to the link https://docs.appdynamics.com/display/PRO45/Build+the+Cluster+Agent+Container+Image and go to the section **Use Pre-Built Cluster Agent Image** and follow the instructions.
