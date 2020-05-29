pipeline {    

    agent any    
    
    environment {
        DTR_FQDN_PORT='ec2-18-185-10-253.eu-central-1.compute.amazonaws.com:4443'
    }

    stages {
        stage('Build') {
            environment {
                DTR_ACCESS_KEY = credentials('jenkins-dtr-access-token')
        MAJORMINOR = '0.0'
            }
            steps {
            sh 'docker --context=buildserver image build -t \
                ${DTR_FQDN_PORT}/engineering/api-build:rc-${MAJORMINOR}.${BUILD_ID} \
                api'
            sh 'docker --context=buildserver login -u jenkins -p ${DTR_ACCESS_KEY} ${DTR_FQDN_PORT}'
            sh 'docker --context=buildserver image push \
                ${DTR_FQDN_PORT}/engineering/api-build:rc-${MAJORMINOR}.${BUILD_ID}'
            }
        }
    }
    
    post {
        always{
            sh 'rm -rf ${WORKSPACE}/*'
        }
    }
}
