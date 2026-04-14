pipeline {
    agent any

    environment {
        KUBECONFIG = '/var/lib/jenkins/.kube/config'
        AWS_DEFAULT_REGION = 'ap-southeast-1'
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
                sh 'docker build -t daneshkabade45/demo:latest .'
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
                    docker push daneshkabade45/demo:latest
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                export KUBECONFIG=/var/lib/jenkins/.kube/config
                aws eks update-kubeconfig --region ap-southeast-1 --name my-cluster
                kubectl apply -f k8s-deploy.yml
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
