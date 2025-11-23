pipeline {
    agent any

    environment {
        APP_NAME = "dockerhello"
        DOCKER_IMAGE = "dockerhello_image"
        K8_NAMESPACE = "dockerhello-ns"
        NODE_PORT = "30200"
    }

    stages {

        stage('Build JAR') {
            steps {
                echo "Building Spring Boot app..."
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                bat "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -f Dockerfile ."
            }
        }

        stage('Prepare K8s Files') {
            steps {
                echo "Preparing Kubernetes YAML files..."
                bat """
                set K8_NAMESPACE=${K8_NAMESPACE}
                set APP_NAME=${APP_NAME}
                set DOCKER_IMAGE=${DOCKER_IMAGE}
                set BUILD_NUMBER=${BUILD_NUMBER}
                set NODE_PORT=${NODE_PORT}

                mkdir k8s_output

                envsubst < k8s/namespace-template.yaml > k8s_output/namespace.yaml
                envsubst < k8s/deployment-template.yaml > k8s_output/deployment.yaml
                envsubst < k8s/service-template.yaml > k8s_output/service.yaml
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying to Kubernetes..."
                bat "kubectl apply -f k8s_output/namespace.yaml"
                bat "kubectl apply -f k8s_output/deployment.yaml"
                bat "kubectl apply -f k8s_output/service.yaml"
            }
        }
    }

    post {
        success {
            echo "Deployment successful!"
        }
        failure {
            echo "Deployment failed."
        }
    }
}
