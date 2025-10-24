pipeline {
    agent any

    environment {
        NODEJS_HOME = tool name: 'NodeJS_18', type: 'NodeJS'
        PATH = "${env.NODEJS_HOME}/bin:${env.PATH}"
        DEPLOY_SERVER = 'ec2-user@your-server-ip'
        DEPLOY_PATH = '/var/www/my-node-app'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/yourusername/my-node-app.git'
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

        stage('Deploy') {
            steps {
                sh """
                scp deploy.sh $DEPLOY_SERVER:$DEPLOY_PATH
                ssh $DEPLOY_SERVER 'cd $DEPLOY_PATH && ./deploy.sh'
                """
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}

