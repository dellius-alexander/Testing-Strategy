///////////////////////////////////////////////////////////
pipeline {
    agent any
    stages {
        sh '''################################################################
################################################################
RED=\'\\033[0;31m\' # Red
NC=\'\\033[0m\' # No Color CAP
source $(find . -type f -iname \'project.env\') 2>/dev/null
__KUBECTL__=$(command -v kubectl)
__DOCKER__=$(command -v docker)
################################################################
################################################################
function __remove_repo__(){
################################################################
if [[ $(ls -lia | grep -c Testing-Strategy)  != 0 ]]; then
        rm -rf  Testing-Strategy
    #
    wait $!
    #
    printf "\\nFound old copy of Testing-Strategy in workspace...\\n"
    printf "\\nDeleted...old version of Testing-Strategy...\\n\\n"
fi
################################################################
}
################################################################
################################################################
function __remove_cntr__(){
################################################################
[[ $(find . -type d -iname \'Testing-Strategy\' | grep -c Testing-Strategy) == 0 ]] \\
&& git clone ${PROJECT_REPO_MAIN} && wait $!
#
source $(find . -type f -iname \'project.env\') 2>/dev/null && wait $!
#
printf "\\nWebserver Deployment file: \\n${__HYFI_DEPLOYMENT__}\\n\\n"
#
#
printf "\\n\\nRemoving running containers or Deployments......\\n\\n"
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
${__DOCKER__} kill $(${__DOCKER__} ps -a | grep cypress | gawk {\'print $1\'} 2>/dev/null) 2>/dev/null
wait $! && echo
${__DOCKER__} rm $(${__DOCKER__} ps -a | grep cypress | gawk {\'print $1\'} 2>/dev/null)  2>/dev/null \\
&& printf "\\n\\n${RED}$1${NC}\\n\\n"
wait $! && echo
#
fi
#
# Remove deployments
#
if [  $(${__KUBECTL__} get deployments.apps -A | grep -c hyfi ) != 0  ]; then
#
printf "\\nDeleting: ${1}\\n\\n"
while [ $(${__KUBECTL__} get deployments.apps -A | grep -c hyfi ) != 0 ]; do
printf "\\n\\nWaiting for old deployment to completely shutdown......\\n\\n"
${__KUBECTL__} get deployments.apps -A | grep hyfi 2>/dev/null
printf "\\n\\n\\n\\n"
${__KUBECTL__} delete -f ${__HYFI_DEPLOYMENT__} 2>/dev/null && wait $! \\
&& printf "\\n\\n\\n\\n"
#
echo & ${__KUBECTL__} delete -f $(find "${JENKINS_HOME}" -type f -iname \'hyfi-deployment.yaml\' -print 2>/dev/null) 2>/dev/null \\
&& wait $! && printf "\\n\\n\\n\\n"
echo & ${__KUBECTL__} delete -f $(find . -type f -iname \'hyfi-deployment.yaml\' -print 2>/dev/null) 2>/dev/null \\
&& wait $! && printf "\\n\\n\\n\\n"
${__KUBECTL__} kubectl delete deployments.apps -n hyfi nginx-hyfi-deployment 2>/dev/null && wait $! && printf "\\n\\n\\n\\n"
wait $!
sleep 2
done
#
fi
#
# Remove www containers
#
#if [  $(${__DOCKER__} ps -a | grep -c www) != 0  ]; then
#
#${__DOCKER__} kill $(${__DOCKER__} ps -a | grep www | gawk {\'print $1\'} 2>/dev/null) 2>/dev/null
#
#wait $! && echo
#
#${__DOCKER__} rm $(${__DOCKER__} ps -a | grep www | gawk {\'print $1\'} 2>/dev/null)  2>/dev/null \\
#&& printf "\\n\\n${RED}$1${NC}\\n\\n"
#
#wait $! && echo
#
#fi
#
#
printf "\\n\\nEnvironment cleaned up......\\n\\n"
#
################################################################
}
################################################################
#                 ... START OF BUILD STEPS ...
################################################################
printf "\\n\\n"
__remove_repo__
#
wait $!
#
[ $? != 0 ] && echo "Something went wrong removing...${?}"
#
__remove_cntr__
#
wait $!
#
[ $? != 0 ] && echo "Something went wrong removing...${?}"


################################################################
git clone ${PROJECT_REPO_MAIN}
#
wait $!
#
cd Testing-Strategy
#
./__init_container__.sh  #2>/dev/null
#
wait $!
#
[ ${?} != 0 ] && echo "Build errors found...${?}" \\
&& exit 4
#
# Remove deployments
if [  $(${__KUBECTL__} get deployments.apps -A | grep -c hyfi ) != 0  ]; then
#
${__KUBECTL__} delete -f ${__HYFI_DEPLOYMENT__}  2>/dev/null \\
&& printf "\\n\\n${RED}$1${NC}\\n\\n"
#
wait $!
#
printf "\\n\\nRemoving Test Deployment.....\\n\\n"
#
fi
#
echo "Build completed......"
'''
    }

}
///////////////////////////////////////////////////////////
// pipeline {
//     agent any
//     stages {
//         stage ('Build'){
//             steps {
//                 // docker build -t dalexander2israel/www_hyfi:v3 -f www.Dockerfile .
//                 dockerfile {
//                     filename 'www.dockerfile'
//                     dir 'build'
//                     label 'dalexander2israel/www_hyfi:v3'
//                     additionalBuildArgs '--build-arg version=1.3.6'
//                     args '-v /tmp:/tmp'
//                 }
//             }
//         }
//     }
// }
///////////////////////////////////////////////////////////
// pipeline {
//     agent {
//         docker { image 'nginx:1.19.3' }
//     }
//     stages {
//         stage('Build image') {
//             steps {
//                 sh 'git clone https://github.com/dellius-alexander/responsive_web_design.git'
//                 sh 'docker build -t dalexander2israel/www_hyfi:v3 -f www.Dockerfile .'
//                 sh 'echo "Building new webservice image complete......"'
//             }
//         }
//         stage('Run new image')
//           steps{
//               sh 'docker run -it -d -P --name www dalexander2israel/www_hyfi:v3'
//               sh 'echo container is up and running......'
//           }
//     }
// }

// podTemplate(
//     name: 'test-pod',
//     label: 'test-pod',
//     containers: [
//         containerTemplate(name: 'nginx-hyfi', image: 'dalexander2israel/nginx-hyfi:v1'),
//     ],
//     // volumes: [
//     //     hostPathVolume(mountPath: '/var/run/docker.sock',
//     //     hostPath: '/var/run/docker.sock',
//     // ],
//     {
//         //node = the pod label
//         node('master'){
//             //container = the container label
//             stage('Build'){
//                 container('nginx-hyfi'){
//                     // This is where we build our code.
//                 }
//             }
//             stage('Build Docker Image'){
//                 container(‘docker’){
//                     // This is where we build the Docker image
//                 }
//             }
//         }
//     })