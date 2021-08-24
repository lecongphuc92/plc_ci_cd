pipeline {

  agent {
      docker {
        image 'python:3.8-slim-buster'
      }
  }

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
        // sh "docker image rm ${DOCKER_IMAGE}:latest"
      }
    }

    stage("Test") {
      steps {
        sh "pip install -U pip"
        sh "pip install pytest"
      }
    }

    stage('Deploy for development') {
      steps {
        sh "chmod +x deploy.sh"
        withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key-staging', keyFileVariable: 'SSH_KEY')]) {
            sh 'ssh -i $SSH_KEY root@149.28.131.8 ./deploy.sh'
        }
        withEnv(['PATH = "$PATH:/usr/local/bin"']){
            echo "PATH is: $PATH"
            sh "./deploy.sh"
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