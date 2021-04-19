  
pipeline{
    agent any
    environment {
        // DOCKER_CERT_PATH is automatically picked up by the Docker client
        // Usage: $DOCKER_CERT_PATH or $DOCKER_CERT_PATH_USR or $DOCKER_CERT_PATH_PSW
        DOCKER_CERT_PATH = credentials('PRIVATE_CNTR_REGISTRY')
    }
    stages {
        stage('Build Test Images...'){
            // parallel { // parallel build stages
                // Building Cypress Image...
                stage('Building Cypress Image'){
                    steps {
                        script {
                            // Define a some variables
                            def cypress_image
                            def cypress_dockerfile
                            // try and catch errors
                            try{
                                sh '''
                                ls -lia;
                                env;
                                sleep 5;
                                '''
                                cypress_dockerfile = '$(find . -type f -name "cypress.Dockerfile")'
                                cypress_image = docker.build("cypress/custom:${env.BUILD_ID}", "-f ${cypress_dockerfile} .")
                                //////////////////////
                                // Push image to repo                         
                                sh '''
                                docker login -u $DOCKER_CERT_PATH_USR -p $DOCKER_CERT_PATH_PSW registry.dellius.app;
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
                        } // End of Script block
                    }
                }
            // } // End of parallel build stages
        } // End of Build Test images stage
    } // End of Main stages
}