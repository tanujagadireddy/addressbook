pipeline {
   agent none
   tools{
         jdk 'myjava'
         maven 'mymaven'
   }
   environment{
       BUILD_SERVER_IP='ec2-user@172.31.32.77'
       IMAGE_NAME='tanuja98/java-mvn-privaterepos:$BUILD_NUMBER'
       ACM_IP='ec2-user@172.31.46.152'
       AWS_ACCESS_KEY_ID =credentials("jenkins_aws_access_key_id")
       AWS_SECRET_ACCESS_KEY=credentials("jenkins_aws_secret_access_key")
        //created a new credential of type secret text to store docker pwd
        DOCKER_REG_PASSWORD=credentials("DOCKER_REG_PASSWORD")

   }
    stages {
        stage('Compile') {
           agent any
            steps {
              script{
                  echo "BUILDING THE CODE"
                  sh 'mvn compile'
              }
            }
            }
        stage('UnitTest') {
        agent any
        steps {
            script{
              echo "TESTING THE CODE"
              sh "mvn test"
              }
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
            }
        stage('PACKAGE+BUILD DOCKERIMAGE AND PUSH TO DOKCERHUB') {
            agent any            
            steps {
                script{
                sshagent(['build_server']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                echo "Packaging the apps"
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER_IP}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_IP} bash /home/ec2-user/server-script.sh ${IMAGE_NAME}"
                //sh "ssh ${BUILD_SERVER_IP} sudo docker build -t ${IMAGE_NAME} /home/ec2-user/addressbook"
                sh "ssh ${BUILD_SERVER_IP} sudo docker login -u $USERNAME -p $PASSWORD"
                sh "ssh ${BUILD_SERVER_IP} sudo docker push ${IMAGE_NAME}"
              }
            }
            }
        }
        }
       stage('Provision the server with TF'){
            environment{
                   AWS_ACCESS_KEY_ID =credentials("jenkins_aws_access_key_id")
                   AWS_SECRET_ACCESS_KEY=credentials("jenkins_aws_secret_access_key")
            }
           agent any
           steps{
               script{
                   echo "RUN THE TF Code"
                   dir('terraform'){
                       sh "terraform init"
                       sh "terraform apply --auto-approve"
                    ANSIBLE_TARGET_EC2_PUBLIC_IP=sh(
                        script: "terraform output ec2-ip",
                        returnStdout: true
                    ).trim()
                    echo "${ANSIBLE_TARGET_EC2_PUBLIC_IP}"
                   }
                                     
               }
           }
       }
       stage("Run the ansible playbook on ACM"){
          agent any
           steps{
               script{
                   echo "Copy the ansible folder to ACM and run the playbook"
                    sshagent(['build_server']) {
                         sh "scp -o StrictHostKeyChecking=no ansible/* ${ACM_IP}:/home/ec2-user"
                 withCredentials([sshUserPrivateKey(credentialsId: 'ANSIBLE_TARGET_KEY',keyFileVariable: 'keyfile',usernameVariable: 'user')]){ 
               // withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                      sh "scp -o StrictHostKeyChecking=no $keyfile ${ACM_IP}:/home/ec2-user/.ssh/id_rsa"  
                 }
                      sh "ssh -o StrictHostKeyChecking=no ${ACM_IP}  bash /home/ec2-user/prepare-playbook.sh ${AWS_ACCESS_KEY_ID} ${AWS_SECRET_ACCESS_KEY} ${DOCKER_REG_PASSWORD} ${IMAGE_NAME}"
                     
                }
            }
            }
                }
                }
                   }
