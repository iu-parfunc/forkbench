def axisBench = ["cilk","rust"] // etc...
def tasks = [:]

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

        // Come on, a "scripting" language w/out foreach iterators?
        for(int i=0; i< axisBench.size(); i++) {
            // Weird, string interpolation, but strangely LIMITED?:
            def axisBenchValue = axisBench[i]
            tasks["${axisBenchValue}"] =
                node(axisBenchValue) {
                  println "Running test ${axisBenchValue}"
                  sh "echo Running test ${axisBenchValue}"
                }
        }
        
        stage("Matrix") {
            parallel tasks
        }        
        stage('After') {
            steps {
//                sh 'make run-all'
                sh 'echo After running tests.'
            }
        }
    }
}
