pipeline {
    agent any

    environment {
        NODE_VERSION = '18'
        DEPLOY_SERVER = 'ubuntu@13.220.91.38'
        DEPLOY_PATH = '/var/www/myapp'
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
                sh 'npm test'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['ubuntu']) {
                    sh """
                        ssh ${DEPLOY_SERVER} 'mkdir -p ${DEPLOY_PATH}'
                        scp -r * ${DEPLOY_SERVER}:${DEPLOY_PATH}
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline succeeded!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}

