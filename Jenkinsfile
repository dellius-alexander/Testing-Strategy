  
pipeline{
    agent any
    environment {
        // DOCKER_CERT_PATH is automatically picked up by the Docker client
        // Usage: $DOCKER_CERT_PATH or $DOCKER_CERT_PATH_USR or $DOCKER_CERT_PATH_PSW
        DOCKER_CERT_PATH = credentials('PRIVATE_CNTR_REGISTRY')
    }
    stages {
        stage('Build Test Images...'){
            steps {
                script {
                    // Define a some variables
                    def cypress_image
                    def cypress_dockerfile
                    
                    try{ // try and catch errors
                        // Test environment...
                        sh '''
                        ls -lia;
                        env;
                        '''
                        // name the dockerfile
                        cypress_dockerfile = 'cypress.Dockerfile'
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
                    cleanWs()
                } // End of script block
            } // End of steps block
        } // End of Build Test images stage()
        stage('Testing image cypress/custom:v5.4.0'){ // Testing stage()
            agent {
                docker { image 'registry.dellius.app/cypress/custom:v5.4.0'}
            }
            steps{
                sh '''
                ls -lia /home/cypress/e2e/cypress/integration;
                cd /home/cypress/e2e/cypress/integration;
                cypress run --project "/home/cypress/e2e/cypress/integration" --headless --browser firefox --spec "/home/cypress/e2e/cypress/integration/test4.spec.js";
                '''
            }
        } // End of Testing stage()
    } // End of Main stages
}
//cypress run --project . --headless --browser firefox --spec '/home/cypress/e2e/cypress/integration/*'