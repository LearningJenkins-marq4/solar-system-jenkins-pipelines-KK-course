// Declarative.
pipeline {
  agent any

  options {
    disableConcurrentBuilds(abortPrevious: true)
  }

  environment {
    DependencyScanReportsPath = "DependencyScanReports"
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
            sh " mkdir -p ${env.DependencyScanReportsPath} "
            script {
              withCredentials(
              [string(credentialsId: 'nvd-api-key', variable: 'NVD_API_KEY')]) {
                withEnv(["SCAN_PATH=${env.DependencyScanReportsPath}"]) {
                  def result = dependencyCheck additionalArguments:
                    '''
                      --scan '.'
                      --out ${SCAN_PATH}
                      --format ALL
                      --prettyPrint
                      --nvdApiKey ${NVD_API_KEY}
                      --disableYarnAudit
                    ''',
                    odcInstallation: 'OWASP-DependencyCheck-1218'

                  if (currentBuild.result == 'FAILURE') {
                    error('Stage failed.')
                  }

                  dependencyCheckPublisher failedTotalCritical: 1, 
                    pattern: "${SCAN_PATH}/dependency-check-report.xml", stopBuild: true
                }
              }
            }
          }
        }
      }
    }

  }
}
