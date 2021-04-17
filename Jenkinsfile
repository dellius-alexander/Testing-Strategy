///////////////////////////////////////////////////////////
pipeline {
    agent any
    stages {
        stage('Setup Environment'){
            steps('Setup'){
                sh '''
                echo "This is just a test";
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