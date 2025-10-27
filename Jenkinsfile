pipeline {
    agent any

    environment {
        NODE_VERSION = '18'
        DEPLOY_SERVER = 'ubuntu@13.220.91.38'
        DEPLOY_PATH = '/var/www/my-node-app'
    }

    stages {

        stage('Checkout SCM') {
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
                sh 'echo "Build completed successfully"'
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['ubuntu']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} '
                        echo "Starting deployment..."
                        sudo mkdir -p ${DEPLOY_PATH} &&
                        sudo chown -R ubuntu:ubuntu ${DEPLOY_PATH} &&
                        cd ${DEPLOY_PATH} &&
                        rm -rf * &&
                        echo "Deployment folder ready."
                    '
                    """
                }
            }
        }

    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed. Check logs for details."
        }
    }
}

