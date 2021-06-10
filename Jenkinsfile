#!/usr/bin/env groovy
def gv
pipeline {
    agent none

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        jdk 'myjava'
        maven 'mymaven'
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                script{
                    git 'https://github.com/devops-trainer/DevOpsClassCodes.git'
                   gv = load "script.groovy"
                    gv.compile()
                }
                
            }
        }
        stage('UnitTest') {
            agent {label 'linux_slave'}
            steps {
               script{
                    git 'https://github.com/devops-trainer/DevOpsClassCodes.git'
                   gv = load "script.groovy"
                   gv.UnitTest()
               }
                
            }
           
        }
        stage('Package') {
            agent any
            steps {
                script{
                    gv.package()
                }
                
            }
         
        }
    }
}
