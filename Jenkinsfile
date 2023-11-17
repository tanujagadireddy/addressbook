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
        DEV_SERVER='ec2-user@172.31.15.80'
        //TEST_SERVER='ec2-user@172.31.39.69'
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
            //s agent {label 'linux_slave'}
            agent any
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
        stage('BUILDING THE DOCKERIMAGE'){
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
                   // sh "ssh ${DEV_SERVER} sudo docker run -itd -P  ${IMAGE_NAME}:${BUILD_NUMBER}"
                     }
                }
            }
        }
        }
        stage("TF create ec2"){
            environment{
                 AWS_ACCESS_KEY_ID =credentials("AWS_ACCESS_KEY_ID")
            AWS_SECRET_ACCESS_KEY=credentials("AWS_SECRET_ACCESS_KEY")
            }
            agent any
            steps{
                script{
                    dir("terraform"){
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                        EC2_PUBLIC_IP=sh(
                            script: "terraform output public-ip",
                            returnStdout: true
                        ).trim()

                    }

                }
            }
        }
         stage('DeploytoQA'){
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
                 echo "Waiting for ec2 instance to initialise"
                 //sleep(time: 90, unit: "SECONDS")
                sshagent(['DEV_SERVER_PACKING']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                echo "Deploying to Test"
                sh "ssh  -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} sudo yum install docker -y"
                sh "ssh  ec2-user@${EC2_PUBLIC_IP} sudo systemctl start docker"
                sh "ssh  ec2-user@${EC2_PUBLIC_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                sh "ssh  ec2-user@${EC2_PUBLIC_IP} sudo docker run -itd -p 8081:8080 ${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }

                }
            }
        }
    }
}