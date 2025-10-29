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
    BRANCH_NAME = "feature/enable-cicd"
    TRIVY = "${WORKSPACE}/trivy-bin/trivy"
  }

  tools {
    nodejs "NodeJS2260"
  }

  stages {

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
*/

/*
    stage('Install dependencies') {
      options {
        timestamps()
      }
      steps {
        sh ' npm install --no-audit '
      }
    }
*/

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

    stage('Unit testing') {
      steps {
        sh ' npm test '
      }
    }
*/

/*
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
*/

    stage('Containerize') {
      stages {
        stage('Build Docker image') {
          steps {
            script {
              dockerImage = docker.build("marq4/learning-jenkins-solar-system:${GIT_COMMIT}")
            }
          }
        }
        /*
        stage('Trivy') {
          steps {
            echo 'Installing Trivy...'
            sh """
              curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b ./trivy-bin
              ${TRIVY} --version
            """
            echo 'Scanning Docker image with Trivy...'
            script {
              sh """
                ${TRIVY} image ${dockerImage.imageName()} \
                  --severity CRITICAL \
                  --exit-code 0 \
                  --format json \
                  --output trivy-image-report.json
              """
            }
          }
        }
        */
        stage('Push Docker image') {
          steps {
            script {
              docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                docker.image(dockerImage.imageName()).push()
              }
            }
          }
        }
      }
      /*
      post {
        always {
          sh """
            echo "Downloading Trivy templates..."
            curl -o html.tpl https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl
            curl -o junit.tpl https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/junit.tpl
            ${TRIVY} convert \
              --format template \
              --template "@html.tpl" \
              --output trivy-image-report.html trivy-image-report.json
            ${TRIVY} convert \
              --format template \
              --template "@junit.tpl" \
              --output trivy-image-report.xml trivy-image-report.json
          """
        }
      }
      */
    }

    stage('Deploy Docker image to EC2') {
      when {
        branch 'feature/*'
      }
      steps {
        script {
          sshagent(['ubuntu-ssh-key-pair-ec2']) {
            sh """
              ssh -o StrictHostKeyChecking=no ubuntu@ec2-18-246-244-210.us-west-2.compute.amazonaws.com "
                if sudo docker ps -a | grep -q 'solar-system'
                then
                  echo 'Container found. Stopping and removing it...'
                  sudo docker stop 'solar-system' && sudo docker rm 'solar-system'
                  echo 'Container stopped and removed.'
                fi 
                sudo docker run --name solar-system -d \
                  -p 3000:3000 \
                  -e MONGO_URI=${MONGO_URI} \
                  -e MONGO_USERNAME=${MONGO_USERNAME} \
                  -e MONGO_PASSWORD=${MONGO_PASSWORD} \
                  ${dockerImage.imageName()}
              "
            """
          }
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
      junit allowEmptyResults: true, skipMarkingBuildUnstable: true,
        testResults: "trivy-image-report.xml"
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
      publishHTML([allowMissing: true, alwaysLinkToLastBuild: true,
        icon: '', keepAll: true, reportDir: './',
        reportFiles: 'trivy-image-report.html',
        reportName: 'Trivy Docker Image Scan Report',
        reportTitles: '', useWrapperFileDirectly: true])
    }
  }

}
