  
pipeline{
    agent any
    environment { // Define some environment variables
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
            // agent {
            //     docker { image 'registry.dellius.app/cypress/custom:v5.4.0'}
            // }
            steps{
                // sh '''
                // cypress run --spec cypress_tests/
                // '''
                try{
                    sh '''
                    docker run --cap-add=sys_nice \
                    --ulimit rtprio=99 \
                    --memory=1024m \
                    -v ${PWD}/cypress_tests/:/home/cypress/e2e/cypress/integration/cypress_tests \
                    -v ${PWD}/video:/home/cypress/e2e/cypress/videos/ \
                    -e DEBUG='cypress:run' \
                    -e PAGELOADTIMEOUT=60000 \
                    -w /home/cypress/e2e --entrypoint=cypress \
                    registry.dellius.app/cypress/custom:v5.4.0  \
                    run --headless --browser firefox --spec "/home/cypress/e2e/cypress/integration/*"
                    '''
                    sh '''
                    echo "Tests passed successfully......";
                    '''
                }
                catch(e){
                    sh '''
                    echo "Intermediate build failure......";
                    '''
                    throw e
                }
            }
        } // End of Testing stage()
        stage('Deploy Webservice to Prod...'){

        }
    } // End of Main stages
}
//cypress run --project . --headless --browser firefox --spec '/home/cypress/e2e/cypress/integration/*'