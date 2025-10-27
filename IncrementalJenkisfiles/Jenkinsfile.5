// Declarative.
pipeline {
  agent any

  options {
    disableConcurrentBuilds(abortPrevious: true)
  }

  environment {
    DependencyScanReportsPath = "DependencyScanReports"
    MONGO_URI = "mongodb+srv://supercluster.d83jj.mongodb.net/superData"
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

    stage('Dependency scanning: parallel(audit + dep check)') {
      parallel {
        stage('NPM Audit') {
          steps {
            sh ' npm audit || true'
          }
        }

        stage('OWASP dependency check') {
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

                  publishHTML([allowMissing: true, alwaysLinkToLastBuild: true,
                    icon: '', keepAll: true, reportDir: 'DependencyScanReports',
                    reportFiles: 'dependency-check-jenkins.html',
                    reportName: 'Dependency Check Jenkins HTML Report',
                    reportTitles: '', useWrapperFileDirectly: true])

                  junit allowEmptyResults: true, skipMarkingBuildUnstable: true,
                    testResults: "${SCAN_PATH}/dependency-check-junit.xml"

                  dependencyCheckPublisher failedTotalCritical: 2, 
                    pattern: "${SCAN_PATH}/dependency-check-report.xml", stopBuild: false
                }
              }
            }
          }
        }
      }
    }

    stage('Unit testing') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'mongo-db-creds',
          passwordVariable: 'MONGO_PASSWORD', usernameVariable: 'MONGO_USERNAME')]) {
            sh ' npm test '
            junit allowEmptyResults: true, skipMarkingBuildUnstable: true,
              testResults: "test-results.xml"
        }
      }
    }

  }
}
