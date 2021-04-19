  
pipeline{
    agent any
    tools {
    // a bit ugly because there is no `@Symbol` annotation for the DockerTool
    // see the discussion about this in PR 77 and PR 52: 
    // https://github.com/jenkinsci/docker-commons-plugin/pull/77#discussion_r280910822
    // https://github.com/jenkinsci/docker-commons-plugin/pull/52
    'org.jenkinsci.plugins.docker.commons.tools.DockerTool' '1.17'
    }
    environment {
        // DOCKER_CERT_PATH is automatically picked up by the Docker client
        // Usage: $DOCKER_CERT_PATH or $DOCKER_CERT_PATH_USR or $DOCKER_CERT_PATH_PSW
        DOCKER_CERT_PATH = credentials('PRIVATE_CNTR_REGISTRY')
    }
    stages {
        stage('Build Test Images...'){
            parallel { // parallel build stages
                stage('Build Docker Image'){
                    steps {
                        script {
                            def www_image
                            //docker.withRegistry('https://registry.dellius.app', 'PRIVATE_CNTR_REGISTRY')
                            git 'https://github.com/dellius-alexander/responsive_web_design.git'
                            // step('Building Webserver Image...') {
                                def www_dockerfile = '$(find ~+ -type f -name "www.Dockerfile")'
                                www_image = docker.build("hyfi_webserver:${env.BUILD_ID}", "-f ${www_dockerfile} .")
                                // docker.withRegistry("https://registry.dellius.app", "${PRIVATE_CNTR_REGISTRY}")
                                // www_image.push('v1.9.3')
                                // Push image to repo
                                try{
                                    sh '''
                                    docker login -u $DOCKER_CERT_PATH_USR -p $DOCKER_CERT_PATH_PSW registry.dellius.app;
                                    docker tag hyfi_webserver:${BUILD_ID} registry.dellius.app/hyfi_webserver:v1.19.3;
                                    docker push registry.dellius.app/hyfi_webserver:v1.19.3;
                                    '''
                                }
                                catch(e){
                                    sh '''
                                    echo "Intermediate build result: ${currentBuild.result}
                                    '''
                                    throw e
                                }

                            // }
                            // step('Pushing Webserver image to private repo...'){
                                //www_image.push()
                            // }
                        }
                    }
                }
                // stage('Building Cypress Image'){
                //     steps {
                //         script {
                //             def cypress_image
                //             //docker.withRegistry('https://registry.dellius.app', 'PRIVATE_CNTR_REGISTRY')
                //             // step('Building Cypress Test Image...') {
                //                 def cypress_dockerfile = '$(find ~+ -type f -name "cypress.Dockerfile")'
                //                 cypress_image = docker.build("cypress/custom:${env.BUILD_ID}", "-f ${cypress_dockerfile} .")
                //                 // Push image to repo          
                //                 sh '''
                //                 docker tag cypress/custom:${BUILD_ID} registry.dellius.app/cypress/custom:v5.4.0
                //                 docker push registry.dellius.app/cypress/custom:v5.4.0
                //                 '''              
                //             // }
                //             // step('Pushing Cypress image to private repo...'){
                //                 //cypress_image.push()
                //             // }
                //         }
                //     }
                // }
            } // End of parallel build stage
        }
    } // End of Main stages
}