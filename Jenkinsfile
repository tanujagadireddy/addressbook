pipeline {
    agent none

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "mymaven"
    }
    environment{
        BUILD_SERVER='ec2-user@172.31.9.109'
        IMAGE_NAME='devopstrainer/java-mvn-privaterepos'
        DEPLOY_SERVER='ec2-user@172.31.14.15'
        ACCESS_KEY=credentials('ACCESS_KEY')
        SECRET_ACCESS_KEY=credentials('SECRET_ACCESS_KEY')
    }
    stages {
        stage('Compile') {
           // agent {label "linux_slave"}
           agent any
            steps {              
              script{
                     echo "COMPILING"
                     sh "mvn compile"
              }             
            }
            
        }
        stage('Test') {
            agent any
            steps {           
              script{
                   echo "RUNNING THE TC"
                   sh "mvn test"
                }              
             
            }            
        
        post{
            always{
                junit 'target/surefire-reports/*.xml'
            }
        }
        }
        stage('Containerise-Build docker image') {
            agent any
            steps {             
                script{
                    sshagent(['slave2']) {
                    //echo "Creating the package"
                   //sh "mvn package"
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user"
                    sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} 'bash server-script.sh ${IMAGE_NAME} ${BUILD_NUMBER}'"
                    sh "ssh ${BUILD_SERVER} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                    sh "ssh ${BUILD_SERVER} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                   
                }             
                }
                }
            }            
        }

        stage('Deploy the docker container to test env'){
            agent any
            steps{
                script{
                    sshagent(['slave2']) {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                     sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} sudo yum install docker -y"
                     sh "ssh ${DEPLOY_SERVER} sudo systemctl start docker"
                     sh "ssh ${DEPLOY_SERVER} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                     sh "ssh ${DEPLOY_SERVER} sudo docker run -itd -P ${IMAGE_NAME}:${BUILD_NUMBER}"

                }
            }
        }

    }
}
      stage('RUN K8S MANIFEST'){
        agent any
           steps{
            script{
                echo "Run the k8s manifest file"
                aws --version
                aws configure set aws_access_key_id ${ACCESS_KEY}
                aws configure set aws_secret_access_key ${SECRET_ACCESS_KEY}
                aws eks update-kubeconfig --region ap-south-1 --name demo2
                /usr/local/bin/kubectl get nodes
                sh 'envsubst < k8s-manifests/java-mvn-app.yml | sudo kubectl apply -f -'
            }
           }
      }
    }
}
