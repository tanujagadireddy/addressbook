pipeline {
    agent none

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "mymaven"
    }  
    environment{
        BUILD_SERVER_IP='ec2-user@18.60.176.237'
       // TEST_SERVER_IP='ec2-user@18.60.87.22'
        IMAGE_NAME='devopstrainer/java-mvn-privaterepos'
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                
                git 'https://github.com/preethid/addressbook.git'                
                sh "mvn compile"    
                           
            }           
        }
        stage('UnitTest') {
            agent any
            steps {                
                sh "mvn test"
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }           
        }
        stage('package+build the dockerimage+push to reg') {
            // agent {label 'linux_slave'}
            // when{
            //     expression{
            //         BRANCH_NAME == 'dev' || BRANCH_NAME == 'develop'
            //     }
            // }
            agent any
            steps {
                script{
                sshagent(['build-server-key']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    echo "Packaging the code on new slave"
                    sh "scp -o StrictHostKeyChecking=no server-config.sh ${BUILD_SERVER_IP}:/home/ec2-user"
                    sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_IP} 'bash ~/server-config.sh ${IMAGE_NAME} ${BUILD_NUMBER}'"                                                       
                    //sh "ssh  ${BUILD_SERVER_IP} sudo docker build -t ${IMAGE_NAME} /home/ec2-user/addressbook-v2"
                    sh "ssh  ${BUILD_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                    sh "ssh  ${BUILD_SERVER_IP} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                }
                }
              
            }           
        }
        }
        stage('Provision TF server'){
            environment{
                AWS_ACCESS_KEY_ID = credentials("jenkins_aws_access_key_id")
                AWS_SECRET_ACCESS_KEY=credentials("jenkins_aws_secret_access_key")
            }
            agent any
            steps{
                script{
                    echo "Apply the TF code"
                    dir('terraform'){
                        sh "terraform init"
                        sh "terraform apply --auto-approve"
                      EC2_PUBLIC_IP=sh(
                        script: "terraform output ec2-public-ip",
                        returnStdout: true
                    ).trim()
                   }
                }
            }
        }
        stage('Deploy'){
            agent any
            input{
                    message "Please approve to deploy"
                    ok "yes, to deploy"
                    parameters{
                        choice(name:'NEWVERSION',choices:['1.2','1.3','1.4'])
                    }
                }
            steps{
                 script{
                sshagent(['build-server-key']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                echo "Deploying to Test"
                sh "ssh  -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} sudo yum install docker -y"
                sh "ssh  ec2-user@${EC2_PUBLIC_IP} sudo systemctl start docker"
                sh "ssh  ec2-user@${EC2_PUBLIC_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                sh "ssh  ec2-user@${EC2_PUBLIC_IP} sudo docker run -itd -P ${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }
        
    }
            }
        }
    }
}
