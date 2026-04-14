pipeline {
    agent any

    environment {
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
        AWS_DEFAULT_REGION = 'ap-southeast-1'
        IMAGE_NAME = 'daneshkabade45/demo'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    tools {
        maven "maven-3.8.4"
    }

    stages {

        stage('Clone Code') {
            steps {
                git 'https://github.com/danesh854/maven-web-app.git'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push $IMAGE_NAME:$IMAGE_TAG
                    docker logout
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                export KUBECONFIG=/var/lib/jenkins/.kube/config

                aws eks update-kubeconfig --region ap-southeast-1 --name my-cluster

                kubectl set image deployment/mavenwebappdeployment \
                mavenwebappcontainer=$IMAGE_NAME:$IMAGE_TAG

                kubectl rollout status deployment/mavenwebappdeployment
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful'
        }
        failure {
            echo '❌ Pipeline Failed'
        }
    }
}
