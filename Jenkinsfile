pipeline {
  agent any
  stages {
    stage('Prebuild') {
      steps {
        sh '''cd scripts
./installer.sh'''
      }
    }

  }
}