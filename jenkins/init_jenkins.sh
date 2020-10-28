#!/usr/bin/env bash
###############################################################################
###############################################################################
###############################################################################
    # Verify kubelet present on host
KUBECTL=$(whereis kubectl | gawk -c '{print $2}')
RED='\033[0;31m' # Red
NC='\033[0m' # No Color CAP
###############################################################################
###############################################################################
###############################################################################
    # Require sudo to run script
if [[ $UID != 0 ]]; then
    printf "\nPlease run this script with sudo: \n";
    printf "\n${RED} sudo $0 $* ${NC}\n\n";
    exit 1
fi
###############################################################################
###############################################################################
###############################################################################
#               VERIFY KUBECTL BINARIES
###############################################################################
function kube_binary(){
    # Require sudo to run script
if [[ -z ${KUBECTL} ]]; then
    printf ("\nUnable to locate ${RED}kubelet${NC} binary. \nPlease re-run this 
    script using the ${RED}--setup${NC} flag.\n Usage:${RED} $0 [ --reset | --setup ]${NC}\n")
    printf "\n$RED}sudo $0 $*${NC}";
    exit 1
fi
}
###############################################################################
###############################################################################
###############################################################################
#       Startup Process
###############################################################################
function nfs_setup(){
    # color highlighting
RED='\033[0;31m' # Red
NC='\033[0m' # No Color CAP
    # source environment file
source jenkins.env
    # verify required package nfs-utils exists
if [[ $(rpm -qa | grep -c "nfs-utils") == 0 ]]; then 
    printf "${RED}Installing nfs-utils to enable nfs volume mounts...${NC}"
    yum install -y nfs-utils
fi
wait $!
    # install firewalld
if [[ $(rpm -qa | grep -c "firewalld") == 0 ]]; then
    printf "${RED}Installing firewalld to enable firewall rules...${NC}"
    yum install -y firewalld
fi
wait $!
    # Create local nfs directory
if [[ $(ls -lia ${__LOCAL_DIRECTORY__} &> /dev/null | grep -c ${__LOCAL_DIRECTORY__}) == 0 ]]; then
    mkdir -p ${__LOCAL_DIRECTORY__}
fi
wait $!
    # Verify and/or start dbus
if [[ $(ls -lia /run/dbus &> /dev/null | grep -c "dbus") == 0  ]]; then
    dbus-uuidgen > /var/lib/dbus/machine-id
    mkdir -p /var/run/dbus
    dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address
fi
wait $!
    # mount nfs volume for jenkins persistent volume 
mount -t nfs -o ${__NFS_REMOTE_HOST__}:${__NFS_VOLUME__}  ${__LOCAL_DIRECTORY__}
wait $!
firewall-cmd --add-service=nfs --zone=internal --permanent
wait $!
firewall-cmd --add-service=mountd --zone=internal --permanent
wait $!
firewall-cmd --add-service=rpc-bind --zone=internal --permanent
wait $!
firewall-cmd --reload
wait $!
printf "\n\nPorts assignments...\n"
firewall-cmd --zone=public --permanent --list-ports
wait $!
    # check if nfs volume set to persist reboot
if [[ $(cat /etc/fstab &> /dev/null | grep -c "${__NFS_VOLUME__}") == 0 ]]; then 
    # set nfs volume to persist reboot
cat >>/etc/fstab <<EOF
${__NFS_REMOTE_HOST__}:${__NFS_VOLUME__}  ${__LOCAL_DIRECTORY__} nfs  rw,defaults 0 0
EOF
fi
wait $!
}
###############################################################################
###############################################################################
###############################################################################
#       Startup Process
###############################################################################
    # verify kubectl binary
kube_binary
    # Setup jenkins.rbac.yaml, namespace & service account
${KUBECTL} apply -f jenkins-rbac.yaml
wait $!
    # Setup the storage class, persistent volume and persistent volume claim
if [[ $(${KUBECTL} get persistentvolume | grep "jenkins" | gawk -c '{print $1}') != "jenkins" ]]; then
    ${KUBECTL} apply -f jenkins-volume.yaml
    wait $!
else
    printf "${RED}Jenkins persistent volume exists...${NC}"
fi
    # Setup the service account and jenkins deployment
${KUBECTL} apply -f jenkins-deployment.yaml
wait $!    