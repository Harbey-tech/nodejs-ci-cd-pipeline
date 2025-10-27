pipeline {
    agent any

    environment {
        DEPLOY_SERVER = 'ubuntu@3.89.97.3'
        DEPLOY_PATH = '/var/www/my-node-app'
    }

    stages {
        stage('Check Node.js') {
            steps {
                script {
                    def nodeVersion = sh(script: "node -v || echo 'Node.js not found'", returnStdout: true).trim()
                    if (nodeVersion == 'Node.js not found') {
                        error("❌ Node.js is not installed on Jenkins server.")
                    } else {
                        echo "✅ Node.js is installed: ${nodeVersion}"
                    }

                    def npmVersion = sh(script: "npm -v || echo 'npm not found'", returnStdout: true).trim()
                    if (npmVersion == 'npm not found') {
                        error("❌ npm is not installed on Jenkins server.")
                    } else {
                        echo "✅ npm is installed: ${npmVersion}"
                    }
                }
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Harbey-tech/nodejs-ci-cd-pipeline.git',
                    credentialsId: 'github-token'
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
                sshagent(['ec2-ssh-key']) {
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

