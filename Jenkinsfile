
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


def jobs = ["haskell", "cilk", "rust", "racket", "manticore", "java-forkjoin", "charm", "chapel"]

def parallelStagesMap = jobs.collectEntries {
    ["${it}" : generateStage(it)]
}

def generateStage(job) {
    return {
        stage("stage: ${job}") {
            options {
                timeout(time: 5, unit: 'MINUTES')
            }
            steps {
                echo "This is ${job}."
                sh script: "make ${job}"
            }
        }
    }
}


pipeline {
    agent {
        // A node RN & IW manually installed Docker on:
        dockerfile /* true */ {
            // filename 'Dockerfile.build'
            // dir 'build'
            label 'cutter02'
            // additionalBuildArgs  '--build-arg version=1.0.2'
        }
    }
    stages {
        
        stage('Build') {
            steps {
                sh 'cat /etc/issue'
                sh 'make build'
//              archiveArtifacts artifacts: 'bin/*', fingerprint: true
            }
        }        
        
        stage ("parallel") {
            steps {
                script {
                    parallel parallelStagesMap
                }
            }
        }
        // stage("Matrix") {
        //     parallel tasks
        // }

        stage('Publish') {
            steps {
//                sh 'make run-all'
                sh 'echo After running tests...'
                sh 'ls ./reports/*/'
                sh 'apt-get -y install tree'
                sh "tree reports -H '.' -L 2 --noreport --charset utf-8 > reports/index.html"
                archiveArtifacts artifacts: 'reports/**/*', fingerprint: true
                publishHTML([
                    allowMissing: false, 
                    alwaysLinkToLastBuild: false, 
                    keepAll: false, 
                    includes: 'reports/**/*',
                    reportDir: 'reports', 
                    reportFiles: 'index.html', 
                    reportName: 'HTML Report', 
                    reportTitles: 'Forkbench Results'
                ])
            }
        }        
    }
}

