def axisBench = ["cilk","rust"] // etc...
def tasks = [:]

// Come on, a "scripting" language w/out foreach iterators?
for(int i=0; i< axisBench.size(); i++) {
    // Weird, string interpolation, but strangely LIMITED?:
    def axisBenchValue = axisBench[i]
    tasks["${axisBenchValue}"] =
        // node(axisBenchValue)
        {
          println "Running test ${axisBenchValue}"
          // sh "echo Running test ${axisBenchValue}"
        }
}

pipeline {
    agent {
        // A node RN & IW manually installed Docker on:
        dockerfile true
    }
    stages {
        stage ("parallel") {
            parallel {
                stage("cilk") {
                    echo "Do cilk"
                }
                stage("rust") {
                    echo "Do rust"
                }
            }
        }
        // stage("Matrix") {
        //     parallel tasks
        // }
    }
}


/*
pipeline {
    // label 'cutter01'
    
    agent {
        // A node RN & IW manually installed Docker on:
        dockerfile true
    }
    stages {
//         stage('Build') {
//             steps {
//                 sh 'pwd'
//                 sh 'cat /etc/issue'
// //              sh 'make build'
// //              archiveArtifacts artifacts: 'bin/*', fingerprint: true
//             }
//         }
        
        stage("Matrix") {
            steps {
                parallel tasks
            }
        }

//         stage('After') {
//             steps {
// //                sh 'make run-all'
//                 sh 'echo After running tests.'
//             }
//         }
    }
}
*/
