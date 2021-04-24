  
pipeline{
    agent any
    options { // Terminal color tool: # Red RD='\e[31m' # Green GR='\e[32m' # Blue BL='\e[36m' $ Cap NC='\e[0m\n'
        ansiColor('xterm')
    }
    environment { // Define some environment variables
        // DOCKER_CERT_PATH is automatically picked up by the Docker client
        // Usage: $DOCKER_CERT_PATH or $DOCKER_CERT_PATH_USR or $DOCKER_CERT_PATH_PSW
        DOCKER_CERT_PATH = credentials('PRIVATE_CNTR_REGISTRY')
        RD='\\e[31m' // Red
        GR='\\e[32m' // Green
        BL='\\e[36m' // Blue
        NC='\\e[0m'  // CAP
    }
    stages {
        stage('Build Test Images...'){
            steps {
                script {
                    // Define a some variables
                    env.BUILD_RESULTS="failure"
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
                        '''
                        // capture your success
                        env.BUILD_RESULTS="success"
                        sh '''
                        printf "\n${GR}Intermediate build ${BUILD_RESULTS}......${NC}\n";
                        '''
                    }
                    catch(e){
                        // capture your failures
                        env.BUILD_RESULTS="failure"
                        sh '''
                        printf "\n${RD}Intermediate build ${BUILD_RESULTS}......${NC}\n";
                        '''
                        throw e
                    }
                    cleanWs() // clean up workspace post-Build
                } // End of script block
            } // Enc of steps()
        } // End of Build Test images stage()
        stage('Testing image cypress/custom:v5.4.0'){ // Testing stage()
            steps('Testing Responsive Web Design Webserver'){
                script{ // Run our newly created test image
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
                        run --headless --browser firefox --spec "/home/cypress/e2e/cypress/integration/*";
                        '''
                        // capture your success
                        env.BUILD_RESULTS="success"
                        sh '''
                        printf "\n${GR}Intermediate build ${BUILD_RESULTS}......${NC}\n";
                        '''
                    }
                    catch(e){
                        // capture your failures
                        env.BUILD_RESULTS="failure"
                        sh '''
                        printf "\n${RD}Intermediate build ${BUILD_RESULTS}......${NC}\n";
                        '''
                        throw e
                    }
                    cleanWs() // clean up workspace post-Testing
                } // End of script block
            } // Enc of steps()
        } // End of Testing stage()
        stage('Check environment'){ // check the status of environment variables
            steps{
                sh '''
                echo "Build Results: ${BUILD_RESULTS}";
                echo "Working with Branch: ${GIT_BRANCH}";
                '''
            }
        }
        stage('Deploy Webservice to Prod...'){
            when {  // Only Deploy the main or master branch
                branch 'main' || 'master'
                environment name: 'BUILD_RESULTS', value: 'success'
            }
            steps('Deploy Webservice to Cloud...'){
                script{ // Re-Deploy to Production cloud environment
                    try{
                        sh '''
                        git clone https://github.com/dellius-alexander/responsive_web_design.git;
                        cd responsive_web_design;
                        kubectl apply -f hyfi-k8s-deployment.yaml;
                        '''
                        // capture your success
                        env.BUILD_RESULTS="success"
                        sh '''
                        printf "\n${GR}Intermediate build ${BUILD_RESULTS}......${NC}\n";
                        '''
                    }
                    catch(e){
                        // capture your failures
                        env.BUILD_RESULTS="failure"
                        sh '''
                        printf "\n${RD}Intermediate build ${BUILD_RESULTS}......${NC}\n";
                        '''
                        throw e
                    }
                    cleanWs() // clean up workspace post-Deploy
                } // End of script block
            } // Enc of steps()            
        } // End of Deploy to Prod stage()
    } // End of Main stages
    post { // Notifications on failures
        failure {
            emailext body: "${env.GIT_AUTHOR_NAME}, Job Name: ${env.JOB_NAME} : #${env.BUILD_NUMBER}  : Results URL: ${env.RUN_DISPLAY_URL}",
                to: "${env.GIT_AUTHOR_EMAIL}",
                subject: "Failed Pipeline Job -> ${env.JOB_NAME} : ${env.currentBuild.fullDisplayName} : Results -> ${env.currentBuild.currentResult}",
                recipientProviders: [developers(), requestor()]
        }
    }
} // End of pipeline