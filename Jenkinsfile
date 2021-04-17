///////////////////////////////////////////////////////////
pipeline {
    agent any
    stages {
        stage('Get responsive web design Repo'){
                steps {
                    sh '''
                    git clone https://github.com/dellius-alexander/responsive_web_design.git;
                    ls -lia;
                    '''
                }

        }
        stage('Build Web Server'){
                steps {
                    sh '''
                    echo "Verify responsive_web_design repo...";
                    RWD_REPO=($(find . -type f -name 'www.Dockerfile'))
                    if [[ "$(basename ${RWD_REPO})" =~ ^(www.Dockerfile)$ ]]; then
                    echo "Repo cloned to build step...";
                    docker build -t registry.dellius.app/hyfi_web:v2.3 -f ${RWD_REPO[0]} .;
                    fi;
                    '''
                }
        }
        stage('Push to Repository'){
            steps{
                sh '''
                echo "Pushing registry.dellius.app/hyfi_web:v2.3 image to container registry";
                docker push registry.dellius.app/hyfi_web:v2.3;
                '''
            }
        }
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