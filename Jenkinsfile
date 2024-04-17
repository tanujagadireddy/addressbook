pipeline {
    agent none

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "mymaven"
    }
    environment{
        BUILD_SERVER='ec2-user@172.31.42.77'
        IMAGE_NAME='devopstrainer/java-mvn-privaterepos'
        //DEPLOY_SERVER='ec2-user@172.31.14.15'
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
        // stage("Provision deploy server with TF"){
        //     environment{
        //          ACCESS_KEY=credentials('ACCESS_KEY')
        //          SECRET_ACCESS_KEY=credentials('SECRET_ACCESS_KEY')
        //     }
        //      agent any
        //            steps{
        //                script{
        //                    dir('terraform'){
        //                    sh "terraform init"
        //                    sh "terraform apply --auto-approve"
        //                    EC2_PUBLIC_IP = sh(
        //                     script: "terraform output instance-ip-0",
        //                     returnStdout: true
        //                    ).trim()
        //                }
        //                }
        //            }
        // }

//         stage('Deploy the docker container to test env'){
//             agent any
//             steps{
//                 script{
//                     sshagent(['slave2']) {
//                     withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
//                      sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} sudo yum install docker -y"
//                      sh "ssh ec2-user@${EC2_PUBLIC_IP} sudo systemctl start docker"
//                      sh "ssh ec2-user@${EC2_PUBLIC_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
//                      sh "ssh ec2-user@${EC2_PUBLIC_IP} sudo docker run -itd -p 8080:8080 ${IMAGE_NAME}:${BUILD_NUMBER}"

//                 }
//             }
//         }

//     }
// }
      stage('RUN K8S MANIFEST via ARGOCD'){
        agent any
           steps{
            script{
                echo "Run the k8s manifest file"
                // sh 'aws --version'
                // sh 'aws configure set aws_access_key_id ${ACCESS_KEY}'
                // sh 'aws configure set aws_secret_access_key ${SECRET_ACCESS_KEY}'
                // sh 'aws eks update-kubeconfig --region ap-south-1 --name myeks1'
                // sh '/usr/local/bin/kubectl get nodes'
                sh 'envsubst < java-mvn-app-var.yml > k8s-manifests/java-mvn-app.yml'
                sh 'git config --global user.name "preethi"'
                sh 'git config --global user.email "preethi@gmail.com"'
                sh 'git add k8s-manifests/java-mvn-app.yml'
                sh 'git commit -m "k8s manifest updated"'
                sh 'git push origin april-argocd'
            }
           }
      }
    }
}
