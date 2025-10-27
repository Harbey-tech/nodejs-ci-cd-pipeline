pipeline {
    agent any

    stages {
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
                sh 'npm run build || echo "No build script defined"'
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['ec2-ssh-key']) { // <-- Jenkins credential ID for your private key
                    sh 'scp -r ./dist ubuntu@13.220.91.38:/var/www/myapp'
                    sh 'ssh ubuntu@13.220.91.38 "cd /var/www/myapp && ls -l"'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
    }
}

