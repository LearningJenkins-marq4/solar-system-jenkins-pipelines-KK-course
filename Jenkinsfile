// Declarative.
pipeline {
  agent any

  environment {
    DependecyScanReportsPath: "DependecyScanReports"
  }

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

    stage('Dependency Scanning parallel(audit + dep check)') {
      parallel {
        stage('NPM Audit') {
          steps {
            sh ' npm audit --audit-level=critical '
          }
        }

        stage('OWASP Dependency Check') {
          steps {
            sh " mkdir ${env.DependecyScanReportsPath} "
            dependencyCheck additionalArguments:
              """
                --scan '.'
                --out ${env.DependecyScanReportsPath}
                --format ALL
                --prettyPrint
              """,
              odcInstallation: 'OWASP-DependencyCheck-1003'
          }
        }
      }
    }

  }
}
