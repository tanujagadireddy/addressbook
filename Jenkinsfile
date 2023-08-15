pipeline {
    agent any

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
            steps {
                
                git 'https://github.com/preethid/addressbook.git'                
                sh "mvn compile"    
                echo "Env to deploy: ${params.Env}"            
            }           
        }
        stage('UnitTest') {
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
            when{
                expression{
                    BRANCH_NAME == 'dev' || BRANCH_NAME == 'develop'
                }
            }
            steps {
               sh "mvn package"
               echo "deploying app version: ${params.APPVERSION}"
            }           
        }
        
    }
}
