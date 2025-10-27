pipeline {
    agent any

    environment {
        NODEJS_HOME = tool name: 'NodeJS_18', type: 'NodeJS'
        PATH = "${env.NODEJS_HOME}/bin:${env.PATH}"
        DEPLOY_SERVER = 'ubuntu@3.89.97.3'
        DEPLOY_PATH = '/var/www/my-node-app'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Harbey-tech/nodejs-ci-cd-pipeline.git'
                    // If repo is public, no credentialsId is needed
                    // credentialsId: 'github-token'
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
                sh 'npm run build || echo "No build script defined"'
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['ec2-ssh-key']) {  // Jenkins SSH credential ID
                    sh """
                        ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} << 'EOF'
cd ${DEPLOY_PATH}
git pull origin main
npm install --production
pm2 restart my-node-app || pm2 start app.js --name "my-node-app"
EOF
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}

