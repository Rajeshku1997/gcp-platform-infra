pipeline {

    agent any

    environment {

        GCP_PROJECT = 'project-76bbd5c2-25dc-4eb3-a36'
        GCP_REGION  = 'asia-south1'
        GKE_CLUSTER = 'devops-gke'

        IMAGE_REPO = 'ghcr.io/rajeshku1997/devops-app'

        K8S_NAMESPACE = 'application'
        DEPLOYMENT    = 'devops-app'
        CONTAINER     = 'devops-app'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Unit Test') {
            steps {
                dir('application') {
                    sh '''
                        set -e

                        python3 --version
                        python3 -m pip --version

                        python3 -m pip install --user -r requirements.txt
                        python3 -m pytest tests/
                    '''
                }
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
                          ./application
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
                        set -e

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
                    set -e

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
                    set -e

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
                    set -e

                    echo "===== DEPLOYMENT ====="

                    kubectl get deployment ${DEPLOYMENT} \
                      -n ${K8S_NAMESPACE}

                    echo "===== PODS ====="

                    kubectl get pods \
                      -n ${K8S_NAMESPACE} \
                      -o wide

                    echo "===== SERVICE ====="

                    kubectl get svc \
                      -n ${K8S_NAMESPACE}

                    echo "===== IMAGE ====="

                    kubectl get deployment ${DEPLOYMENT} \
                      -n ${K8S_NAMESPACE} \
                      -o jsonpath='{.spec.template.spec.containers[0].image}'

                    echo
                '''
            }
        }
    }

    post {

        success {
            echo 'Application CI/CD pipeline completed successfully.'
        }

        failure {
            echo 'Application CI/CD pipeline failed.'
        }

        always {
            echo 'Pipeline execution completed.'
        }
    }
}
