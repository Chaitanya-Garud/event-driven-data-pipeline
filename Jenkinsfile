pipeline {
    agent any

    environment {
        AWS_REGION = "ap-northeast-1"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Package Lambda Functions') {
            steps {
                sh 'chmod +x scripts/package.sh'
                sh './scripts/package.sh'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds'
                    ]]) {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds'
                    ]]) {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
}
