#!/usr/bin/env bash
################################################################
################################################################
__KUBECTL__=$(command -v kubectl)
__DOCKER__=$(command -v docker)
__HYFI_DEPLOYMENT__=$(find "${JENKINS_HOME}" -type f -iname 'hyfi-deployment.yaml' -print 2>/dev/null \
|| find . -type f -iname 'hyfi-deployment.yaml' -print 2>/dev/null) 2>/dev/null
################################################################
################################################################
function __remove_repo__(){
################################################################
if [[ $(ls -lia | grep -c Testing-Strategy)  != 0 ]]; then
	rm -rf  Testing-Strategy
    #
    wait $!
    #
    printf "\nFound old copy of Testing-Strategy in workspace...\n"
    printf "\nDeleted...old version of Testing-Strategy...\n\n"
fi
################################################################
}
################################################################
################################################################
function __remove_cntr__(){
################################################################
printf "\n\nRemoving running containers or Deployments......\n\n"
${__DOCKER__} ps -a | grep www 2>/dev/null
wait $!
${__DOCKER__} ps -a | grep cypress 2>/dev/null
wait $!
${__KUBECTL__} get deployments.apps -A | grep hyfi 2>/dev/null
wait $!
# Remove cypress containers
if [  $(${__DOCKER__} ps -a | grep -c cypress) != 0  ]; then
  ${__DOCKER__} kill $(${__DOCKER__} ps -a | grep cypress | gawk {'print $1'} 2>/dev/null) 2>/dev/null
  wait $!
  ${__DOCKER__} rm $(${__DOCKER__} ps -a | grep cypress | gawk {'print $1'} 2>/dev/null)  2>/dev/null
  wait $!
fi
# Remove www containers
if [  $(${__DOCKER__} ps -a | grep -c www) != 0  ]; then
  ${__DOCKER__} kill $(${__DOCKER__} ps -a | grep www | gawk {'print $1'} 2>/dev/null) 2>/dev/null
  wait $!
  ${__DOCKER__} rm $(${__DOCKER__} ps -a | grep www | gawk {'print $1'} 2>/dev/null)  2>/dev/null
  wait $!
fi
# Remove deployments
if [  $(${__KUBECTL__} get deployments.apps -A | grep -c hyfi ) != 0  ]; then
	${__KUBECTL__} delete deployments.apps -n hyfi nginx-hyfi-deployment  2>/dev/null
    wait $!
fi
#    
printf "\n\nEnvironment cleaned up......\n\n"
#
################################################################
}
################################################################
################################################################
__remove_repo__
#
wait $!
#
[ $? != 0 ] && echo "Something went wrong removing $0"
#
__remove_cntr__
#
wait $!
#
[ $? != 0 ] && echo "Something went wrong removing $0"


################################################################
git clone ${PROJECT_REPO_MAIN}
#
wait $!
#
cd Testing-Strategy
#
./__init_container__.sh  2>/dev/null
#
wait $!
#
[ ${?} != 0 ] && echo "Build errors found...${?}" \
&& exit 4
#
# Remove deployments
if [  $(${__KUBECTL__} get deployments.apps -A | grep -c hyfi ) != 0  ]; then
        ${__KUBECTL__} delete deployments.apps -n hyfi nginx-hyfi-deployment  2>/dev/null
    wait $!
    printf "\n\nRemoving Test Deployment.....\n\n"
fi
echo "Build completed......"