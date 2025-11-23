pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "dockerhello_image"
        CONTAINER_NAME = "dockerhello_container"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "📥 Checking out code from GitHub..."
                git branch: 'main', url: 'https://github.com/ruthvika1536/dockerhello'
            }
        }

        stage('Build JAR') {
            steps {
                echo "🛠️ Building Spring Boot JAR..."
                bat "mvn clean package -DskipTests"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker Image..."
                bat "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -f Dockerfile ."
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    echo "🛑 Stopping previous container (if exists)..."
                    bat "docker stop ${CONTAINER_NAME} || exit 0"
                    bat "docker rm ${CONTAINER_NAME} || exit 0"

                    echo "🚀 Starting new Docker container..."
                    bat "docker run -d --name ${CONTAINER_NAME} -p 8200:8200 ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD Success! App deployed via Docker."
        }
        failure {
            echo "❌ Pipeline Failed! Check logs."
        }
    }
}
