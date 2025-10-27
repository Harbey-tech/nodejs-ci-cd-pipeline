pipeline {
    agent any

    stages {
        stage('Check Node.js') {
            steps {
                script {
                    // Check Node.js version
                    def nodeVersion = sh(script: "node -v || echo 'Node.js not found'", returnStdout: true).trim()
                    if (nodeVersion == 'Node.js not found') {
                        error("❌ Node.js is not installed on this Jenkins server.")
                    } else {
                        echo "✅ Node.js is installed: ${nodeVersion}"
                    }

                    // Check npm version
                    def npmVersion = sh(script: "npm -v || echo 'npm not found'", returnStdout: true).trim()
                    if (npmVersion == 'npm not found') {
                        error("❌ npm is not installed on this Jenkins server.")
                    } else {
                        echo "✅ npm is installed: ${npmVersion}"
                    }
                }
            }
        }

        stage('Build') {
            steps {
                echo "You can continue your Node.js build steps here."
            }
        }
    }

    post {
        failure {
            echo "❌ Pipeline failed due to missing Node.js/npm."
        }
    }
}

