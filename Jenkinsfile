  
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
                // stage('Build Docker Image'){
                //     steps {
                //         script {
                //             def www_image
                //             git 'https://github.com/dellius-alexander/responsive_web_design.git'
                //             def www_dockerfile = '$(find ~+ -type f -name "www.Dockerfile")'
                //             www_image = docker.build("hyfi_webserver:${env.BUILD_ID}", "-f ${www_dockerfile} .")
                //             //////////////////////
                //             // Push image to repo
                //             try{
                //                 sh '''
                //                 docker login -u $DOCKER_CERT_PATH_USR -p $DOCKER_CERT_PATH_PSW registry.dellius.app;
                //                 docker tag hyfi_webserver:${BUILD_ID} registry.dellius.app/hyfi_webserver:v1.19.3;
                //                 docker push registry.dellius.app/hyfi_webserver:v1.19.3;
                //                 echo "Intermediate build success......;"
                //                 '''
                //             }
                //             catch(e){
                //                 sh '''
                //                 echo "Intermediate build failure......";
                //                 '''
                //                 throw e
                //             }
                //         }
                //     }
                // }
                stage('Building Cypress Image'){
                    steps {
                        script {
                            def cypress_image
                            git 'https://github.com/dellius-alexander/Testing-Strategy.git'
                            def cypress_dockerfile = '$(find ~+ -type f -name "cypress.Dockerfile")'
                            cypress_image = docker.build("cypress/custom:${env.BUILD_ID}", "-f ${cypress_dockerfile} .")
                            //////////////////////
                            // Push image to repo  
                            try{
                                sh '''
                                docker tag cypress/custom:${BUILD_ID} registry.dellius.app/cypress/custom:v5.4.0;
                                docker push registry.dellius.app/cypress/custom:v5.4.0;
                                echo "Intermediate build success......";
                                '''
                            }
                            catch(e){
                                sh '''
                                echo "Intermediate build failure......";
                                '''
                                throw e
                            }
                        }
                    }
                }
            } // End of parallel build stage
        }
    } // End of Main stages
}