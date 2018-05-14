pipeline {
    agent {
        dockerfile true
    }
    stages {
        stage('Build') {
            steps {
		sh 'make build'
                archiveArtifacts artifacts: 'bin/*', fingerprint: true
            }
        }
        stage('Test') {
            steps {
                sh 'make run-all'
            }
        }
    }
}
