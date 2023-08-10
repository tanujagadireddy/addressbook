pipeline{
    agent none
    tools{
        jdk 'myjava'
        maven 'mymaven'
    }
    environment{
        IMAGE_NAME ='devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
        BUILD_SERVER_IP ='ec2-user@13.126.223.241'
        APP_NAME='java-mvn-app'
        }

    stages{
        stage("COMPILE"){
            agent any
            steps{
                script{
                  echo "COMPILIG THE CODE"
                  sh 'mvn compile'
                }
            }
        }
        stage("UNITTEST"){
            //agent {label 'linux_slave'}
            agent any
         steps{
           script{
               echo "Testing THE CODE"
                sh 'mvn test'
                }
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage("PACKAGE+BUILD THE DOCKER IMAGE"){
            agent any
            steps{
            script{
                echo "Packaging THE CODE"
                sshagent(['build-server-key']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER_IP}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_IP} 'bash ~/server-script.sh'"
                sh "ssh ${BUILD_SERVER_IP} sudo docker build -t ${IMAGE_NAME} /home/ec2-user/addressbook"
                sh "ssh ${BUILD_SERVER_IP} sudo docker login -u $USERNAME -p $PASSWORD"
                sh "ssh ${BUILD_SERVER_IP} sudo docker push ${IMAGE_NAME}"
                }
        }
    }
}     
        }
    stage("Deploy the docker image on k8s cluster"){
    agent any
        steps{
            script{
                echo "RUN THE APP ON K8S CLUSTER"
                sh 'envsubst < java-mvn-deploy-svc.yml | sudo /usr/local/bin/kubectl apply -f -'
                 }
            }
                 }
    }
}
