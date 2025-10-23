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

/*
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
*/

    stage('OWASP Dependency Check version') {
      steps {
				dependencyCheck additionalArguments: 
					'--version', odcInstallation: 'OWASP-DependencyCheck-1003'
      }
    }

    stage('Verify suppression XML file is found') {
      steps {
        script {
          sh ' ls -la suppression.xml '
        }
      }
    }

    stage('Test NVD connection') {
      steps {
        withCredentials([string(credentialsId: 'nvd-api-key', variable: 'NVD_API_KEY')]) {
          sh '''
            curl -v -H "apiKey: ${NVD_API_KEY}" \
            "https://services.nvd.nist.gov/rest/json/cves/2.0?resultsPerPage=1"
          '''
        }
      }
    }

    stage('Update NVD Database') {
      steps {
        script {
          withCredentials([string(credentialsId: 'nvd-api-key', variable: 'NVD_API_KEY')]) {
            def dcHome = tool name: 'OWASP-DependencyCheck-1003', type: 'dependency-check'
            sh """
              ${dcHome}/bin/dependency-check.sh \\
              --updateonly \\
              --nvdApiKey ${NVD_API_KEY} \\
              --nvdApiDelay 8000
            """
          }
        }
      }
    }

/*
    stage('VERBOSE OWASP DC') {
      steps {
        sh " mkdir -p ${env.DependecyScanReportsPath} "
        //sh ' rm -rf ~/.dependency-check-data/ '
        withCredentials([string(credentialsId: 'nvd-api-key', 
          variable: 'NVD_API_KEY')]) {
            dependencyCheck additionalArguments:
            """
              --scan '.'
              --out ${env.DependecyScanReportsPath}
              --format ALL
              --prettyPrint
              --nvdApiKey ${NVD_API_KEY}
              --suppression suppression.xml
              --log dependency-check.log
              --nvdApiDelay 8000
              --nvdMaxRetryCount 15
              --connectiontimeout 120000
            """,
            odcInstallation: 'OWASP-DependencyCheck-1003'
        }
        archiveArtifacts artifacts: dependency-check.log, allowEmptyArchive: true
      }
    }
*/

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
