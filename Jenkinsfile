pipeline {
    agent any

    environment {
        DEPLOY_SERVER = 'ubuntu@<EC2_PUBLIC_IP>'
        DEPLOY_PATH = '/var/www/my-node-app'
        SSH_KEY = '/var/lib/jenkins/.ssh/id_rsa'  // adjust if needed
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/<username>/<repo>.git',
                    credentialsId: 'github-token'
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build || echo "No build script"'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                echo "Deploying to EC2..."
                ssh -o StrictHostKeyChecking=no -i $SSH_KEY $DEPLOY_SERVER "mkdir -p $DEPLOY_PATH"
                rsync -avz -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" ./ $DEPLOY_SERVER:$DEPLOY_PATH
                ssh -i $SSH_KEY -o StrictHostKeyChecking=no $DEPLOY_SERVER "
                    cd $DEPLOY_PATH &&
                    npm install &&
                    nohup npm start > app.log 2>&1 &
                "
                '''
            }
        }
    }
}

