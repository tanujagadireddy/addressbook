pipeline {
    agent none

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "mymaven"
    }
    parameters{
         string(name:'Env',defaultValue:'Test',description:'env to deploy')
         booleanParam(name:'executeTests',defaultValue: true,description:'decide to run tc')
          choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])

    }

    stages {
        stage('Compile') {
            agent any
            steps {
                
                git 'https://github.com/preethid/addressbook.git'                
                sh "mvn compile"    
                echo "Env to deploy: ${params.Env}"            
            }           
        }
        stage('UnitTest') {
            agent any
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps {                
                sh "mvn test"
            }           
        }
        stage('package') {
            agent {label 'linux_slave'}
            // when{
            //     expression{
            //         BRANCH_NAME == 'dev' || BRANCH_NAME == 'develop'
            //     }
            // }

            steps {
               sh "mvn package"
               echo "deploying app version: ${params.APPVERSION}"
            }           
        }
        stage('Deploy'){
            agent {label 'linux_slave'}
            input{
                    message "Please approve to deploy"
                    ok "yes, to deploy"
                    parameters{
                        choice(name:'NEWVERSION',choices:['1.2','1.3','1.4'])
                    }
                }
            steps{
                
                echo "Deploying to Test"
            }
        }
        
    }
}
