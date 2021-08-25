pipeline {

  agent any

  environment {
    DOCKER_IMAGE = "lecongphuc92/plc_ci_cd"
  }

  stages {
    stage("Build") {
      environment {
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
      }
      steps {
        sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . "
        sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
        sh "docker image ls | grep ${DOCKER_IMAGE}"
        withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
            sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
            sh "docker push ${DOCKER_IMAGE}:latest"
        }

        //clean to save disk
        sh "docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
        sh "docker image rm ${DOCKER_IMAGE}:latest"
      }
    }

    stage("Test") {
      steps {
        echo "Testinggg"
      }
    }

    stage('Deploy for development') {
      steps {
        sh "chmod +x deploy.sh"
        withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key-staging', keyFileVariable: 'SSH_KEY')]) {
            sh 'ssh -i $SSH_KEY -o StrictHostKeyChecking=no ubuntu@18.142.51.134 "docker stop django-app && docker rm django-app && docker run -d -p 8000:8000 --name django-app ${DOCKER_IMAGE}:latest"'
        }
      }
    }
  }

  post {
    success {
      echo "SUCCESSFUL"
    }
    failure {
      echo "FAILED"
    }
  }
}