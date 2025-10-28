// Declarative.
pipeline {
  agent any

  options {
    disableConcurrentBuilds(abortPrevious: true)
  }

  environment {
    DependencyScanReportsPath = "DependencyScanReports"
    MONGO_URI = "mongodb+srv://supercluster.d83jj.mongodb.net/superData"
    MONGO_USERNAME = credentials('MONGO_USERNAME')
    MONGO_PASSWORD = credentials('MONGO_PASSWORD')
    SONAR_SCANNER_HOME = tool 'sonarqube-scanner-73'
  }

  tools {
    nodejs "NodeJS2260"
  }

  stages {

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

    stage('Install dependencies') {
      options {
        timestamps()
      }
      steps {
        sh ' npm install --no-audit '
      }
    }

/*
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
                  dependencyCheckPublisher failedTotalCritical: 2, 
                    pattern: "${SCAN_PATH}/dependency-check-report.xml", stopBuild: false
                }
              }
            }
          }
        }
      }
    }
*/

    stage('Unit testing') {
      steps {
        sh ' npm test '
      }
    }

    stage('Code coverage') {
      steps {
        catchError(buildResult: 'SUCCESS', message: 'Ignoring for now', stageResult: 'UNSTABLE') {
          sh ' npm run coverage '
        }
      }
    }

    stage('SonarQube analysis') {
      steps {
        echo "${SONAR_SCANNER_HOME}"
        timeout(10) {
          withSonarQubeEnv('Local-Docker-SonarQube') {
            sh """
              ${SONAR_SCANNER_HOME}/bin/sonar-scanner \
                -Dsonar.projectKey=Solar-System \
                -Dsonar.sources=app.js \
                -Dsonar.javascript.lcov.reportPaths=./coverage/lcov.info
            """
          }
          waitForQualityGate abortPipeline: true
        }
      }
    }

  }

  post {
    always {
      junit allowEmptyResults: true, skipMarkingBuildUnstable: true,
        testResults: "${DependencyScanReportsPath}/dependency-check-junit.xml"
      junit allowEmptyResults: true, skipMarkingBuildUnstable: true,
        testResults: "test-results.xml"
      publishHTML([allowMissing: true, alwaysLinkToLastBuild: true, icon: '',
        keepAll: true, reportDir: 'DependencyScanReports',
        reportFiles: 'dependency-check-jenkins.html',
        reportName: 'Dependency Check Jenkins HTML Report',
        reportTitles: '', useWrapperFileDirectly: true])
      publishHTML([allowMissing: true, alwaysLinkToLastBuild: true,
        icon: '', keepAll: true, reportDir: 'coverage/lcov-report',
        reportFiles: 'index.html',
        reportName: 'Code Coverage Report',
        reportTitles: '', useWrapperFileDirectly: true])
    }
  }

}
