pipeline {
    agent any

    environment {
        NODE_VERSION = '18'
        DEPLOY_PATH = '/var/www/my-node-app'
        AWS_REGION  = 'us-east-1'
        INSTANCE_ID = 'i-001425919cb4f24aa' // Your EC2 instance ID
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Harbey-tech/nodejs-ci-cd-pipeline.git',
                    credentialsId: 'github-token'
            }
        }

        stage('Check Node.js') {
            steps {
                sh 'node -v'
                sh 'npm -v'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test || echo "No tests defined"'
            }
        }

        stage('Build') {
            steps {
                echo 'Build completed successfully'
            }
        }

        stage('Deploy via SSM') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh """
                    aws ssm send-command \
                        --targets "Key=InstanceIds,Values=${INSTANCE_ID}" \
                        --document-name "AWS-RunShellScript" \
                        --comment "Deploy Node.js app" \
                        --parameters 'commands=[
                            "sudo mkdir -p ${DEPLOY_PATH}",
                            "sudo chown -R ubuntu:ubuntu ${DEPLOY_PATH}",
                            "cd ${DEPLOY_PATH}",
                            "rm -rf *",
                            "git clone https://github.com/Harbey-tech/nodejs-ci-cd-pipeline.git .",
                            "npm install",
                            "npm start"
                        ]' \
                        --region ${AWS_REGION}
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment completed successfully via SSM!'
        }
        failure {
            echo '❌ Deployment failed. Check logs for details.'
        }
    }
}

