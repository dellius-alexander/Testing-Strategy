#!/usr/bin/env bash
################################################################
################################################################
RED='\033[0;31m' # Red
NC='\033[0m' # No Color CAP
__KUBECTL__=$(command -v kubectl)
__DOCKER__=$(command -v docker)
export __HYFI_DEPLOYMENT__=$(find "${JENKINS_HOME}" -type f -iname 'hyfi-deployment.yaml' -print 2>/dev/null \
|| find . -type f -iname 'hyfi-deployment.yaml' -print 2>/dev/null) 2>/dev/null
printf "\n\n${__HYFI_DEPLOYMENT__}\n\n"
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
wait $! && echo
${__DOCKER__} ps -a | grep cypress 2>/dev/null
wait $! && echo
${__KUBECTL__} get deployments.apps -A | grep hyfi 2>/dev/null
wait $! && echo
# Remove cypress containers
#
if [  $(${__DOCKER__} ps -a | grep -c cypress) != 0  ]; then
#
${__DOCKER__} kill $(${__DOCKER__} ps -a | grep cypress | gawk {'print $1'} 2>/dev/null) 2>/dev/null
wait $! && echo
${__DOCKER__} rm $(${__DOCKER__} ps -a | grep cypress | gawk {'print $1'} 2>/dev/null)  2>/dev/null \
&& printf "\n\n${RED}$1${NC}\n\n"
wait $! && echo
#
fi
#
# Remove deployments
#
if [  $(${__KUBECTL__} get deployments.apps -A | grep -c hyfi ) != 0  ]; then
#
printf "\nDeleting: ${1}\n\n"
${__KUBECTL__} delete -f ${__HYFI_DEPLOYMENT__} 2>/dev/null && wait $!  && sleep 3 \
&& printf "\n\n"
#
wait $!
#
fi
#
# Remove www containers
#
#if [  $(${__DOCKER__} ps -a | grep -c www) != 0  ]; then
#
#${__DOCKER__} kill $(${__DOCKER__} ps -a | grep www | gawk {'print $1'} 2>/dev/null) 2>/dev/null
#
#wait $! && echo
#
#${__DOCKER__} rm $(${__DOCKER__} ps -a | grep www | gawk {'print $1'} 2>/dev/null)  2>/dev/null \
#&& printf "\n\n${RED}$1${NC}\n\n"
#
#wait $! && echo
#
#fi
#
#
printf "\n\nEnvironment cleaned up......\n\n"
#
################################################################
}
################################################################
#                 ... START OF BUILD STEPS ...
################################################################
__remove_repo__
#
wait $!
#
[ $? != 0 ] && echo "Something went wrong removing...$0"
#
__remove_cntr__
#
wait $!
#
[ $? != 0 ] && echo "Something went wrong removing...$0"


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
#
${__KUBECTL__} delete -f ${__HYFI_DEPLOYMENT__}  2>/dev/null \
&& printf "\n\n${RED}$1${NC}\n\n"
#
wait $!
#
printf "\n\nRemoving Test Deployment.....\n\n"
#
fi
#
echo "Build completed......"
