  
pipeline{
    agent any
    environment {
        // DOCKER_CERT_PATH is automatically picked up by the Docker client
        // Usage: $DOCKER_CERT_PATH or $DOCKER_CERT_PATH_USR or $DOCKER_CERT_PATH_PSW
        DOCKER_CERT_PATH = credentials('PRIVATE_CNTR_REGISTRY')
    }
    stages {
        stage('Build Test Images...'){
            parallel { // parallel build stages
                stage('Parallel Build Webserver Image'){
                    steps {
                        dir("responsive_web_design"){
                            checkout scm
                            cleanWs()
                            script {
                                def www_image
                                sh '''
                                // git clone https://github.com/dellius-alexander/responsive_web_design.git;
                                ls -lia ../;
                                ls -lia;
                                '''
                                def www_dockerfile = '$(find ~+ -type f -name "www.Dockerfile")'
                                www_image = docker.build("hyfi_webserver:${env.BUILD_ID}", "-f ${www_dockerfile} .")
                                //////////////////////
                                // Push image to repo
                                try{
                                    sh '''
                                    docker login -u $DOCKER_CERT_PATH_USR -p $DOCKER_CERT_PATH_PSW registry.dellius.app;
                                    docker tag hyfi_webserver:${BUILD_ID} registry.dellius.app/hyfi_webserver:v1.19.3;
                                    docker push registry.dellius.app/hyfi_webserver:v1.19.3;
                                    echo "Intermediate build success......;"
                                    '''
                                }
                                catch(e){
                                    sh '''
                                    echo "Intermediate build failure......";
                                    '''
                                    throw e
                                }
                            } // End of Scrit block
                            cleanWs()
                        }
                    }
                }
                // // Building Cypress Image...
                // stage('Building Cypress Image'){
                //     steps {
                //         // dir("cypress_test"){
                //             //cleanWs()
                //             script {
                //                 sh 'ls -lia'
                //                 def cypress_image
                //                 def cypress_dockerfile = '$(find . -type f -name "cypress.Dockerfile")'
                //                 cypress_image = docker.build("cypress/custom:${env.BUILD_ID}", "-f ${cypress_dockerfile} .")
                //                 //////////////////////
                //                 // Push image to repo  
                //                 try{
                //                     sh '''
                //                     docker login -u $DOCKER_CERT_PATH_USR -p $DOCKER_CERT_PATH_PSW registry.dellius.app;
                //                     docker tag cypress/custom:${BUILD_ID} registry.dellius.app/cypress/custom:v5.4.0;
                //                     docker push registry.dellius.app/cypress/custom:v5.4.0;
                //                     echo "Intermediate build success......";
                //                     '''
                //                 }
                //                 catch(e){
                //                     sh '''
                //                     echo "Intermediate build failure......";
                //                     '''
                //                     throw e
                //                 }
                //             } // End of Script block
                //         // } // cypress_test dir
                //     }
                // }
            } // End of parallel build stages
        } // End of Build Test images stage
    } // End of Main stages
}