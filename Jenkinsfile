pipeline {

  agent {
      docker {
        image 'python:3.8-slim-buster'
        args '-u 0:0 -v /tmp:/root/.cache'
      }
  }

  environment {
    DOCKER_IMAGE = "lecongphuc92/plc_ci_cd"
  }

  stages {
    stage("Test") {
      steps {
        sh "pip install -U pip"
        sh "pip install pytest"
      }
    }

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

    stage('Deploy for development') {
        environment {
            PATH = "$PATH:/usr/local/bin"
        }
        when {
            branch 'staging'
        }
        steps {
            sh "chmod +x deploy.sh"
            sh "./deploy.sh"
        }
    }
    stage('Deploy for production') {
        environment {
            PATH = "$PATH:/usr/local/bin"
        }
        when {
           branch 'master'
        }
        steps {
            sh "chmod +x deploy.sh"
            sh "./deploy.sh"
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