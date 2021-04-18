  
pipeline{
    agent any
    stages {
        stage('Build Test Images...'){
            parallel { // parallel build stages
                stage('Build Docker Image'){
                    steps {
                        node {
                            def www_image
                            docker.withRegistry('https://registry.dellius.app', 'PRIVATE_CNTR_REGISTRY')
                            git 'https://github.com/dellius-alexander/responsive_web_design.git'
                            step('Building Webserver Image...') {
                                def www_dockerfile = 'www.Dockerfile'
                                www_image = docker.build("hyfi_webserver:${env.BUILD_ID}", "-f ${www_dockerfile} .")
                            }
                            step('Pushing Webserver image to private repo...'){
                                www_image.push()
                            }
                        }
                    }
                }
                stage('Building Cypress Image'){
                    steps {
                        node {
                            def cypress_image
                            docker.withRegistry('https://registry.dellius.app', 'PRIVATE_CNTR_REGISTRY')
                            step('Building Cypress Test Image...') {
                                def cypress_dockerfile = 'cypress.Dockerfile'
                                cypress_image = docker.build("cypress/custom:5.4.0:${env.BUILD_ID}", "-f ${cypress_dockerfile} .")                        
                            }
                            step('Pushing Cypress image to private repo...'){
                                cypress_image.push()
                            }
                        }
                    }
                }
            } // End of parallel build stage
        }
    }
}