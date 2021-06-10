#!/usr/bin/env groovy
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
                  sh 'mvn compile'
                }
                
            }
        }
        stage('UnitTest') {
            agent {label 'linux_slave'}
            steps {
               script{
                   git 'https://github.com/devops-trainer/DevOpsClassCodes.git'
                   sh 'mvn test'
               }
                
            }
           
        }
        stage('Package') {
            agent any
            steps {
                script{
                    sh 'mvn package'
                }
                
            }
         
        }
    }
}
