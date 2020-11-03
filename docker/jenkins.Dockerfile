# escape=\ (backslash)
### <REQUIRED SCRIPT>: kubelet.sh
################################################################
################################################################
FROM jenkins/jenkins:lts-centos
# Make changes as user root
USER root
# verify build ARG's
RUN echo "Jenkins home: /var/jenkins_home"
# Setup environment variables
ENV DOCKER_HOST=unix:///var/run/docker.sock
ENV HOST_UID=1003
ENV JENKINS_HOME=/var/jenkins_home
ENV KUBECONFIG=/var/jenkins_home/secrets/kubeconfig
# Update & install docker, kubectl, kubelet
RUN yum update -y && yum install -y yum-utils
RUN  yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
RUN yum install -y docker-ce docker-ce-cli containerd.io
# Kubernetes Setup Add yum repository
COPY ./kubectl.sh /
RUN chmod +x kubectl.sh && \
sh kubectl.sh
RUN yum install -y kubectl
RUN usermod -u ${HOST_UID} jenkins
RUN usermod -aG docker jenkins && newgrp docker
# EXPOSE PORTS
EXPOSE 80
EXPOSE 8080
EXPOSE 50000
# Change to User Jenkins
USER jenkins
