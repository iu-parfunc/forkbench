pipeline {
    agent {
        dockerfile true
    }
    stages {
        stage('Test') {
            steps {
		sh './jenkins_worker.sh'
            }
        }
    }
}
