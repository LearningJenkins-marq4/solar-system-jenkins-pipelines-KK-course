// Declarative.
pipeline {
  agent any

  tools {
    nodejs "NodeJS2260"
  }

  stages{

    stage('Display message') {
      steps {
        echo "Jenkins has been able to find this file and execute the Pipeline!"
      }
    }

    stage('Node versions') {
      steps {
        sh '''
            node -v
            npm -v
        '''
      }
    }

    stage('Install dependencies'){
      steps {
        sh ' npm install --no-audit '
      }
    }

  }
}
