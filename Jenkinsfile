pipeline {    

    agent any    
    
    environment {
        DOCKER_TLS_VERIFY='1'                                                                                               
        COMPOSE_TLS_VERSION='TLSv1_2'                                                                                       
        DOCKER_CERT_PATH='/home/jenkins/admincerts'                                                                       
        DOCKER_HOST='tcp://<UCP FQDN>:443'
        DTR_FQDN_PORT='<DTR_FQDN>:4443'
    }

    stages {
        stage('Build') {
            environment {
                DTR_ACCESS_KEY = credentials('jenkins-dtr-access-token')
            }
            steps {
                script {
                    docker image build -t ${DTR_FQDN_PORT}/engineering/db:1.0 database
                    docker image build -t ${DTR_FQDN_PORT}/engineering/api:rc-1.0-build-${BUILD_ID} api
                    docker login -u jenkins -p ${DTR_ACCESS_KEY} ${DTR_FQDN_PORT}
                    docker image push ${DTR_FQDN_PORT}/engineering/db:1.0
                    docker image push ${DTR_FQDN_PORT}/engineering/api:rc-1.0-build-${BUILD_ID}
                }
            }
        }
    }
}
