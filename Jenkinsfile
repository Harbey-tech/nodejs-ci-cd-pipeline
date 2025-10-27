pipeline {
    agent any

    environment {
        NODE_VERSION = '18'
        DEPLOY_SERVER = 'ubuntu@13.220.91.38'
        DEPLOY_PATH = '/var/www/my-node-app'
    }

    stages {

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

        stage('Build') {
            steps {
                echo 'Build completed successfully'
            }
        }

       stage('Deploy') {
    steps {
        sshagent(['ec2-ssh-key']) {
            sh """
            ssh -o StrictHostKeyChecking=no $DEPLOY_SERVER "
                sudo mkdir -p ${DEPLOY_PATH} &&
                sudo chown -R ubuntu:ubuntu ${DEPLOY_PATH} &&
                cd ${DEPLOY_PATH} &&
                rm -rf *
            "
            
            scp -o StrictHostKeyChecking=no -r * $DEPLOY_SERVER:${DEPLOY_PATH}
            
            ssh -o StrictHostKeyChecking=no $DEPLOY_SERVER "
                cd ${DEPLOY_PATH} &&
                npm install &&
                nohup npm start > app.log 2>&1 &
            "
            """
        }
    }
}


    post {
        success {
            echo '✅ Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed. Check logs for details.'
        }
    }
}

