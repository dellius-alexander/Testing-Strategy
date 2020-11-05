# Jenkins Deployment
---
*Note: To create your own bare-metal k8s cluster see [dellius-alexander/kubernetes](https://github.com/dellius-alexander/kubernetes)*

---
## Deploy Jenkins
---
---
<br/>
We have made setting up Jenkins much simpler by defining our jenkins deployment within the corresponding YAML files, they define the resources and context of our Jenkins Kubernetes (k8s) deployment.  
<br/><br/>
In order to properly run jenkins we will need to create each resource object below by accessing the Kubernetes API Server.  Each Yaml file contains the definitions for each Jenkins resource object used for:
<br/><br/>

- ***[Service Account](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)***, ***[ClusterRole](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole)*** & ***[RoleBindings](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding)*** --- [jenkins-rbac.yaml](./jenkins-rbac.yaml)
- ***[StorageClass](https://kubernetes.io/docs/concepts/storage/storage-classes/#the-storageclass-resource)***, ***[PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistent-volumes)*** & ***[PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)*** --- [jenkins-volume.yaml](./jenkins-volume.yaml)
- ***[Jenkins Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)***, ***[Jenkins Service](https://kubernetes.io/docs/concepts/services-networking/service/#service-resource)*** --- [jenkins-deployment.yaml](./jenkins-deployment.yaml)
<br/><br/>

Use kubectl to define our resource via the k8s API:
```bash
# create a Jenkins namespace
$ kubectl create namespace jenkins
  namespace/jenkins created
# Deploy Jenkins resources
$ kubectl apply -f jenkins-rbac.yaml && \
  kubectl apply -f jenkins-volume.yaml && \
  kubectl apply -f jenkins-deployment
```
Once jenkins is running. We can access the jenkins service via: ***http:\/\/Kubernetes_API_Server_URL\>:\<Service_Port\>***
- [http://10.240.0.12:32307](#)

You can retrieve these using ***kubectl***. [See below](#KubernetesServerURL&Ports)

---
### First Time Accessing Jenkins
---
<br/>
You will need the admin access token upon initial setup. Once you have created the first admin account this option will not work again.  You will have to delete your entire jenkins data to reset defaults, so don't forget your password. But this assumes you have access to the persisted volume location where Jenkins installed up initial deployment. Enter the following command to retrieve the Jenkins admin password upon first startup.  
<br/><br/>

```bash
# This will be removed after you setup admin account.
$ kubectl exec -it -n jenkins jenkins-deployment-<unique_hash> -- \
  cat /var/jenkins_home/secrets/initialAdminPassword
```
<p><strong>Thats is you're all set to start using jenkins. Please see:</strong>
<a href="https://www.jenkins.io/doc/book/installing/kubernetes/" id="JenkinsInstallReference">Jenkins install reference for more details</a>


---
---
### Init Jenkins Script (Alternative)
---
As an alternative you may choose to use the ***[init_jenkins.sh](./init_jenkins.sh)*** scripts or start Jenkins using ***kubectl*** as shown above.<br/>

---
---
## Authentication
---
If you plan to use Jenkins to connect to the k8s cluster resources you will need the Service Account token and k8s API Server CA. When a Service Account is created, a secret is automatically generated and attached to it. This secret contains base64 encoded information that can be used to authenticate to the Kubernetes API Server as this ServiceAccount: <br/>
(Note: You will need these to interact with the Pod using jenkins.)

- the Kubernetes API Server CA Certificate
- the Service Account token
- Kubernetes URL: the Kubernetes API Server URL

*These objects will be needed if you intend to setup cloud services authentication to the k8s cluster.  This will enable the Jenkins service account to access Pod and the k8s cluster resources.*

---
### 1. Service Account
Retrieve the ServiceAccount token with this one liner command (the value 
will be required to configure Jenkins credentials later on):

```bash
# Retrieve the ServiceAccount token
$ kubectl get secret $(kubectl get sa -n jenkins jenkins \
  -o jsonpath={.secrets[0].   name}) \
  -n jenkins -o jsonpath={.data.token} | base64 --decode
```
---
### 2. Kubernetes API Server URL & Port<a id="KubernetesServerURL&Ports"></a>
*This will be needed later when configuring Jenkins field reference: k8s API Server URL & Port*
```bash
# Jenkins Server URL
$ kubectl config view --minify | grep server

     server: https://10.240.0.12:6443

# Jenkins Service Port
$ kubectl get -n jenkins services | gawk -p {'print $5'} | cut -c 1-14

  PORT(S)
# <container port>:<service port>
  8080:32307/TCP
```
---
### 3. Kubernetes API Server CA Certificate
Retrieve the Kubernetes API Server CA Certificate this one liner command 
(the value will be required to configure the kubernetes plugin later on):

```bash
# Retrieve the Kubernetes API Server CA Certificate
$ kubectl get secret $(kubectl get sa -n jenkins jenkins \
-o jsonpath={.secrets[0].name}) \
-n jenkins -o jsonpath={.data.'ca\.crt'} | base64 --decode
```
(Note: For more details about those values, have a look at [Kubernetes - Authentication - Service Account Tokens](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#service-account-tokens))

---

### 4. Authentication w/ Kubernetes Plugin

The Kubernetes Plugin offers different methods to authenticate to a remote Kubernetes cluster:

- Secret Text Credentials: using a Service Account token (see [Kubernetes - Authentication - Service Account Tokens](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#service-account-tokens))
- Secret File Credentials: using a KUBECONFIG file (see [Kubernetes - Organizing Cluster Access Using kubeconfig Files](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/))
- Username/Password Credentials: using a username and password (see [Kubernetes - Authentication - Static Password File authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#static-password-file))
- Certificate Credentials: using client certificates (see [Kubernetes - Manage TLS Certificates in a Cluster](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/))
- Evolution of my Jenkins Environment (see [Jenkins and Kubernetes - Secret Agents in the Clouds](https://www.jenkins.io/blog/2018/09/14/kubernetes-and-secret-agents/))

---