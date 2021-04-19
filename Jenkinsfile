  
pipeline{
    agent any
    options {
        ansiColor('xterm')
    }
    environment { // Define some environment variables
        // DOCKER_CERT_PATH is automatically picked up by the Docker client
        // Usage: $DOCKER_CERT_PATH or $DOCKER_CERT_PATH_USR or $DOCKER_CERT_PATH_PSW
        DOCKER_CERT_PATH = credentials('PRIVATE_CNTR_REGISTRY')
        BUILD_RESULTS="failure"
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
                        export BUILD_RESULTS="success";
                        '''
                    }
                    catch(e){
                        sh '''
                        echo "Intermediate build failure......";
                        export BUILD_RESULTS="failure";
                        '''
                        throw e
                    }
                    cleanWs()
                } // End of script block
            } // End of steps block
        } // End of Build Test images stage()
        stage('Testing image cypress/custom:v5.4.0'){ // Testing stage()
            steps('Testing Responsive Web Design Webserver'){
                script{
                    try{
                        sh '''
                        docker run --cap-add=sys_nice \
                        --ulimit rtprio=99 \
                        --memory=1024m \
                        -v ${PWD}/cypress_tests/:/home/cypress/e2e/cypress/integration/cypress_tests \
                        -v ${PWD}/video:/home/cypress/e2e/cypress/videos/ \
                        -e DEBUG='' \
                        -e PAGELOADTIMEOUT=60000 \
                        -e CYPRESS_RECORD_KEY="U2FyYWlAMjAwOQ==" \
                        -w /home/cypress/e2e --entrypoint=cypress \
                        registry.dellius.app/cypress/custom:v5.4.0  \
                        run --headless --browser firefox --spec "/home/cypress/e2e/cypress/integration/projectplan_sizing2.spec.js"
                        '''
                        sh '''
                        echo "Tests passed successfully......";
                        export BUILD_RESULTS="success";
                        '''
                    }
                    catch(e){
                        sh '''
                        echo "Intermediate build failure......";
                        export BUILD_RESULTS="failure";
                        '''
                        throw e
                    }
                }
            }
        } // End of Testing stage()
        stage('Deploy Webservice to Prod...'){
            when {
                environment name: 'BUILD_RESULTS', value: 'failure'             
            }

            steps('Deploy Webservice to Cloud...'){
                script{
                    try{
                        sh '''
                        kubectl get all -A;
                        git clone https://github.com/dellius-alexander/responsive_web_design.git;
                        cd responsive_web_design;
                        kubectl apply -f hyfi-k8s-deployment.yaml;
                        '''                        
                    }
                    catch(e){
                        sh '''
                        echo "Intermediate build failure......";
                        export BUILD_RESULTS="failure";
                        '''
                        throw e
                    }
                }
            }
        } // End of Deploy to Prod stage()
    } // End of Main stages
}
//cypress run --project . --headless --browser firefox --spec '/home/cypress/e2e/cypress/integration/*'