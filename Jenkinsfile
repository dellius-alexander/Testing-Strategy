  
pipeline{
    agent any
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
                                // Push image to repo
                                sh '''
                                docker tag hyfi_webserver:${BUILD_ID} registry.dellius.app/hyfi_webserver:v1.19.3
                                docker login -u dalexander -p ${PRIVATE_CNTR_REGISTRY}registry.dellius.app 
                                docker push registry.dellius.app/hyfi_webserver:v1.19.3
                                '''
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