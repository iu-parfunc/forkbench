
/*
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
*/


def jobs = ["JobA", "JobB", "JobC"]

def parallelStagesMap = jobs.collectEntries {
    ["${it}" : generateStage(it)]
}

def generateStage(job) {
    return {
        stage("stage: ${job}") {
                echo "This is ${job}."
                sh script: "sleep 15"
        }
    }
}


pipeline {
    agent {
        // A node RN & IW manually installed Docker on:
        dockerfile /* true */ {
            // filename 'Dockerfile.build'
            // dir 'build'
            label 'cutter01'
            // additionalBuildArgs  '--build-arg version=1.0.2'
        }
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
        
        stage ("parallel") {
            steps {
                script {
                    parallel parallelStagesMap
                }
            }
/*            
            parallel {
                stage("cilk") {
                    steps {                        
                        echo "Do cilk"
                    }
                }
                stage("rust") {
                    steps {                        
                        echo "Do rust"
                    }
                }
            }
*/
        }
        // stage("Matrix") {
        //     parallel tasks
        // }

        stage('After') {
            steps {
//                sh 'make run-all'
                sh 'echo After running tests...'
            }
        }        
    }
}

