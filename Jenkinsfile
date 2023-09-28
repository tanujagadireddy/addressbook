pipeline{
    agent none

    tools{
        jdk 'myjava'
        maven 'mymaven'
    }
    // parameters{
    //     string(name:'Env',defaultValue:'Test',description:'env to deploy')
    //     booleanParam(name:'executeTests',defaultValue: true,description:'decide to run tc')
    //     choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])
    // }
    environment{
        DEV_SERVER='ec2-user@172.31.7.48'
        IMAGE_NAME='devopstrainer/java-mvn-privaterepos'
    }

    stages{
        stage('compile'){
            agent any
            steps{
                script{
                   echo "Compile the Code"
                    //echo "Deploying to env: ${params.Env}"
                    sh "mvn compile"
                }
            }
        }
        stage('UnitTest'){
             agent {label 'linux_slave'}
            //agent any
            // when{
            //     expression{
            //         params.executeTests == true
            //     }
            // }
            steps{
                script{
                    echo "Run the UnitTest Cases"
                    sh "mvn test"
                }
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('package'){
            agent any
            steps{
                script{
                    sshagent(['DEV_SERVER_PACKING']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    echo "Package the Code"
                    //echo "Packing the code version ${params.APPVERSION}"
                    sh "scp -o StrictHostKeyChecking=no server-config.sh ${DEV_SERVER}:/home/ec2-user"
                    sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER} 'bash ~/server-config.sh ${IMAGE_NAME} ${BUILD_NUMBER}'"
                    sh "ssh ${DEV_SERVER} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                    sh "ssh ${DEV_SERVER} sudo docker push  ${IMAGE_NAME}:${BUILD_NUMBER}"
                    sh "ssh ${DEV_SERVER} sudo docker run -itd -P  ${IMAGE_NAME}:${BUILD_NUMBER}"
                     }
                }
            }
        }
        }
         stage('Deploy'){
            agent any
            input{
                message "Select the version to package"
                ok "Version selected"
                parameters{
                    choice(name:'NEWVERSION',choices:['DEV','ONPREM','EKS'])
                }
            }
            steps{
                script{
                    echo "Package the Code"
                    //echo "Packing the code version ${params.APPVERSION}"

                }
            }
        }
    }
}