  
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
                // Building Cypress Image...
                stage('Building Cypress Image'){
                    steps {
                        script {
                            // Define a some variables
                            def cypress_image
                            def cypress_dockerfile
                            // try and catch errors
                            try{
                                // Test environment...
                                sh '''
                                ls -lia;
                                env;
                                '''
                                // find the dockerfile
                                cypress_dockerfile = '$(find . -type f -name "cypress.Dockerfile")'
                                // build the cypress test image
                                cypress_image = docker.build("cypress/custom:${env.BUILD_ID}", "-f ${cypress_dockerfile} .")
                                // Login to private container registry:
                                //   - [ registry.dellius.app ]                  
                                sh '''
                                docker login -u $DOCKER_CERT_PATH_USR -p $DOCKER_CERT_PATH_PSW registry.dellius.app;
                                '''
                                // tag the cypress image to private repository
                                sh '''
                                docker tag cypress/custom:${BUILD_ID} registry.dellius.app/cypress/custom:v5.4.0;
                                '''
                                // Push image to private container registry
                                sh '''
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
                        } // End of Script block
                    }
                }
            } // End of parallel build stages
        } // End of Build Test images stage
    } // End of Main stages
}