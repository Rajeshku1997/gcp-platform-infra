pipeline {

    agent any

    environment {

        GCP_PROJECT = 'project-76bbd5c2-25dc-4eb3-a36'
        GCP_REGION  = 'asia-south1'
        GKE_CLUSTER = 'devops-gke'

        IMAGE_REPO = 'ghcr.io/rajeshku1997/devops-app'

        APP_DIR = 'customer-service/'

        K8S_NAMESPACE = 'application'
        DEPLOYMENT = 'devops-app'
        CONTAINER = 'devops-app'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {

                script {

                    env.IMAGE_TAG = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()

                    echo "Building image:"
                    echo "${IMAGE_REPO}:${IMAGE_TAG}"

                    sh """
                        docker build \
                          -t ${IMAGE_REPO}:${IMAGE_TAG} \
                          ${APP_DIR}
                    """
                }
            }
        }

        stage('Security Scan') {
            steps {

                sh """
                    trivy image \
                      --severity HIGH,CRITICAL \
                      --exit-code 1 \
                      ${IMAGE_REPO}:${IMAGE_TAG}
                """
            }
        }

        stage('Push Image') {
            steps {

                withCredentials([
                    usernamePassword(
                        credentialsId: 'ghcr-creds',
                        usernameVariable: 'GHCR_USER',
                        passwordVariable: 'GHCR_TOKEN'
                    )
                ]) {

                    sh '''
                        echo "$GHCR_TOKEN" | docker login ghcr.io \
                          -u "$GHCR_USER" \
                          --password-stdin

                        docker push ${IMAGE_REPO}:${IMAGE_TAG}

                        docker logout ghcr.io
                    '''
                }
            }
        }

        stage('Deploy to GKE') {
            steps {

                sh '''

                    gcloud container clusters get-credentials \
                      ${GKE_CLUSTER} \
                      --region ${GCP_REGION} \
                      --project ${GCP_PROJECT}

                    kubectl set image deployment/${DEPLOYMENT} \
                      ${CONTAINER}=${IMAGE_REPO}:${IMAGE_TAG} \
                      -n ${K8S_NAMESPACE}

                '''
            }
        }

        stage('Rollout Verification') {
            steps {

                sh '''

                    kubectl rollout status \
                      deployment/${DEPLOYMENT} \
                      -n ${K8S_NAMESPACE} \
                      --timeout=5m

                '''
            }
        }

        stage('Smoke Test') {
            steps {

                sh '''

                    echo "===== Pods ====="

                    kubectl get pods \
                      -n ${K8S_NAMESPACE} \
                      -o wide

                    echo "===== Service ====="

                    kubectl get svc \
                      -n ${K8S_NAMESPACE}

                    echo "===== Image ====="

                    kubectl get deployment ${DEPLOYMENT} \
                      -n ${K8S_NAMESPACE} \
                      -o jsonpath='{.spec.template.spec.containers[0].image}'

                    echo

                    echo "===== Application Test ====="

                    kubectl run curl-test \
                      --rm \
                      -i \
                      --restart=Never \
                      --image=curlimages/curl \
                      -n ${K8S_NAMESPACE} \
                      -- \
                      curl -f http://devops-app/

                '''
            }
        }
    }

    post {

        success {
            echo 'APPLICATION CI/CD SUCCESS'
        }

        failure {
            echo 'APPLICATION CI/CD FAILED'
        }

        always {
            echo 'Pipeline execution completed'
        }
    }
}
