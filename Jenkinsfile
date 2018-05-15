pipeline {
    agent {
        dockerfile true
    }
    stages {
        stage('Build') {
            steps {
                sh 'pwd'
                sh 'cat /etc/issue'
//              sh 'make build'
//              archiveArtifacts artifacts: 'bin/*', fingerprint: true
            }
        }
        stage('Test') {
            steps {
//                sh 'make run-all'
                sh 'echo DO TEST'
            }
        }
    }
}
