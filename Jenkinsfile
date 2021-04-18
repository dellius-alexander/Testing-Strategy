pipeline{
    agent any
    stages {
        stage('Build Docker Image'){
            steps {
                node master {
                    git 'https://github.com/dellius-alexander/responsive_web_design.git'
                    step {
                        def www_dockerfile = 'www.dockerfile'
                        def www_image = docker.build("hyfi_webserver:${env.BUILD_ID}", "-f ${www_dockerfile} .")
                    }

                }
            }

        }
    }
}



