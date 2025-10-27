pipeline {
    agent any

    environment {
        NODE_VERSION = '18'
        DEPLOY_USER = 'ubuntu'
        DEPLOY_HOST = '13.220.91.38'
        DEPLOY_PATH = '/var/www/myapp'
    }

    stages {

        stage('Checkout Code') {
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
                sh 'echo "No build needed for Node.js backend"'
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                        # Ensure the deployment directory exists
                        ssh $DEPLOY_USER@$DEPLOY_HOST 'mkdir -p $DEPLOY_PATH'

                        # Copy files
                        scp -r ./* $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH
                    """
                }
            }
        }

        stage('Check Deployment Logs') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                        echo "Fetching deployment logs..."
                        ssh $DEPLOY_USER@$DEPLOY_HOST 'tail -n 50 $DEPLOY_PATH/deploy.log || echo "No deploy log found"'
                    """
                }
            }
        }

    }

    post {
        success {
            echo '✅ Pipeline finished successfully!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}

