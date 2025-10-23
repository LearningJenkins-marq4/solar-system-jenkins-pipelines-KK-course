// Declarative.
pipeline {
  agent any

  options {
    disableConcurrentBuilds(abortPrevious: true)
  }

  environment {
    DependecyScanReportsPath = "DependecyScanReports"
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

    stage('OWASP Dependency Check version') {
      steps {
        dependencyCheck --version
      }
    }

/*
    stage('Dependency Scanning parallel(audit + dep check)') {
      parallel {
        stage('NPM Audit') {
          steps {
            sh ' npm audit --audit-level=critical '
          }
        }

        stage('OWASP Dependency Check') {
          steps {
            sh " mkdir -p ${env.DependecyScanReportsPath} "
            script {
              withCredentials(
              [string(credentialsId: 'nvd-api-key', variable: 'NVD_API_KEY')]) {
                withEnv(["SCAN_PATH=${env.DependecyScanReportsPath}"]) {
                  def result = dependencyCheck additionalArguments:
                    '''
                      --scan '.'
                      --out ${SCAN_PATH}
                      --format ALL
                      --prettyPrint
                      --nvdApiKey ${NVD_API_KEY}
                      --suppression suppression.xml
                    ''',
                    odcInstallation: 'OWASP-DependencyCheck-1003'

                  if (currentBuild.result == 'FAILURE') {
                    error('Stage failed.')
                  }
                }
              }
            }
          }
        }
      }
    }
*/

  }
}
