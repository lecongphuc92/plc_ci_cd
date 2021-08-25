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
        withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key-staging', keystoreVariable: 'SSH_KEY')]) {
            sh 'ssh -i $SSH_KEY -o StrictHostKeyChecking=no root@149.28.131.8 ./deploy.sh'
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