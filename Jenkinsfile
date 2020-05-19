pipeline {    

    agent any    
    
    environment {
        DTR_FQDN_PORT='<DTR_FQDN>:4443'
    }

    stages {
        stage('Build') {
            environment {
                DTR_ACCESS_KEY = credentials('jenkins-dtr-access-token')
		MAJORMINOR = '0.0'
            }
            steps {
                sh 'docker --context=buildserver image build -t ${DTR_FQDN_PORT}/engineering/api-build:rc-${MAJORMINOR}.${BUILD_ID} api'
                sh 'docker --context=buildserver image build --target test -t ${DTR_FQDN_PORT}/engineering/api-build:unittest-${MAJORMINOR}.${BUILD_ID} api'
                sh 'docker --context=buildserver image build -t ${DTR_FQDN_PORT}/engineering/api-build:integration-${MAJORMINOR}.${BUILD_ID} api/integration'
                sh 'docker --context=buildserver login -u jenkins -p ${DTR_ACCESS_KEY} ${DTR_FQDN_PORT}'
                sh 'docker --context=buildserver image push ${DTR_FQDN_PORT}/engineering/api-build:rc-${MAJORMINOR}.${BUILD_ID}'
                sh 'docker --context=buildserver image push ${DTR_FQDN_PORT}/engineering/api-build:unittest-${MAJORMINOR}.${BUILD_ID}'
                sh 'docker --context=buildserver image push ${DTR_FQDN_PORT}/engineering/api-build:integration-${MAJORMINOR}.${BUILD_ID}'
            }
        }

        stage('Integration') {
            environment {
                DTR_ACCESS_KEY = credentials('jenkins-dtr-access-token')
            }
            steps {
                // deploy our application for integration testing
                sh 'BUILDNO=$(echo ${TAG} | sed "s/.*\.//"); \
                    helm install integrationtest --namespace testing --wait helm --set API.tag=rc-${MAJORMINOR}.${BUILDNO}'
                // make sure all pods are up before we try to run the integration tests
                sh 'DBPOD=$(kubectl get pod -l app=db -n test -o jsonpath="{.items[0].metadata.name}"); \
                    APIPOD=$(kubectl get pod -l app=api -n test -o jsonpath="{.items[0].metadata.name}"); \
                    kubectl wait --timeout=60s --for=condition=Ready pod/${DBPOD} -n test; \
                    kubectl wait --timeout=60s --for=condition=Ready pod/${APIPOD} -n test'

                // run integration tests
                sh 'BUILDNO=$(echo ${TAG} | sed "s/.*\.//"); \
                    kubectl run integration-${BUILDNO} 
                        --image ${DTR_FQDN_PORT}/engineering/api-build:integration-${MAJORMINOR}.${BUILDNO} \
                        -n testing --restart=Never --attach=True; \
                    helm uninstall integrationtest --namespace test'
            }
        }
    }
    
    post {
        always{
            sh 'rm -rf ${WORKSPACE}/* ; \
                helm uninstall integrationtest --namespace test'
        }
    }
}
