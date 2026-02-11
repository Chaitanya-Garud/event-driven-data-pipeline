pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Checking out source code..."
                checkout scm
            }
        }

        stage('Package Lambda Functions') {
            steps {
                echo "Packaging Lambda functions..."
                sh 'chmod +x scripts/package.sh'
                sh './scripts/package.sh'
            }
        }

        stage('Terraform Init') {
            steps {
                echo "Initializing Terraform..."
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "Planning infrastructure changes..."
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "Applying infrastructure changes..."
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo "Deployment completed successfully!"
        }
        failure {
            echo "Pipeline failed. Please check logs."
        }
    }
}
