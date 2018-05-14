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
    }
    stages {
        stage('Test') {
            steps {
                sh 'make run-all'
            }
        }
    }
}
