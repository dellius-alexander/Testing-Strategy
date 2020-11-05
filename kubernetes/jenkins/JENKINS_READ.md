# Jenkins Deployment
---
## Deploy Jenkins
---
### Init Jenkins Script
---
You may choose to use the ***[init_jenkins.sh](init_jenkins.sh)*** scripts or start Jenkins using ***kubectl*** in this order: <br/><br/>
In order to properly run jenkins we will need to create each object below by accessing the Kubernetes API Server.  Each Yaml file contains the contexts for each object:
- jenkins-rbac.yaml: ***Service Accont***, ***ClusterRole*** & ***RoleBindings***
- jenkins-volume.yaml: ***StorageClass***, ***PersistentVolume*** & ***PersistentVolumeClaim***
- jenkins-deployment.yaml: ***Jenkins Deployment***, ***Jenkins Service***

```bash
# create a jenkins namespace
$ kubectl create namespace jenkins
  namespace/jenkins created
# Deploy jenkins resources
$ kubectl apply -f jenkins-rbac.yaml && \
  kubectl apply -f jenkins-volume.yaml && \
  kubectl apply -f jenkins-deployment
```
Once jenkins is running. We can access the jenkins service via: ***http:\/\/Kubernetes_API_Server_URL\>:\<Service_Port\>***
- [http://10.240.0.12:32307](#)

You can retrieve these using ***kubectl***. [See below](#KubernetesServerURL&Ports)

---
## Authentication
Retrieve the Service Account token and API Server CA. When a Service Account is created, a secret is automatically generated and 
attached to it. This secret contains base64 encoded information that can be 
used to authenticate to the Kubernetes API Server as this ServiceAccount: <br/>
(Note: You will need these to interact with the Pod using jenkins.)

- the Kubernetes API Server CA Certificate
- the Service Account token
- Kubernetes URL: the Kubernetes API Server URL
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
### 2. Kubernetes Server URL & Ports<a id="KubernetesServerURL&Ports"></a>
Kubernetes URL: the Kubernetes API Server URL & Port
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
---
## TODO