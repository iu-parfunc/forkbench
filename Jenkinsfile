pipeline {
    agent {
        docker { image 'parfunc/compile-o-rama:0.2' }
    }
    stages {
        stage('Test') {
            steps {
                sh 'node --version'
            }
        }
    }
}
