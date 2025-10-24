pipeline {
    agent any

    
    environment {
    NODEJS_HOME = tool name: 'NodeJS_25', type: 'NodeJS'
    PATH = "${env.NODEJS_HOME}/bin:${env.PATH}"
    DEPLOY_SERVER = 'ec2-user@<EC2_PUBLIC_IP>'
    DEPLOY_PATH = '/var/www/my-node-app'
}



    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/<yourusername>/nodejs-ci-cd-pipeline.git'
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
                sh '''
                    ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} << 'EOF'
                    cd ${DEPLOY_PATH}
                    git pull origin main
                    npm install --production
                    pm2 restart my-node-app || pm2 start app.js --name "my-node-app"
                    EOF
                '''
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

