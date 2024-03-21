pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "mymaven"
    }

    parameters{
           string(name:'Env',defaultValue:'Test',description:'version to deploy')
        booleanParam(name:'executeTests',defaultValue: true,description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])


    }

    stages {
        stage('Compile') {
            steps {
               echo "compiling teh code ${params.APPVERSION}"
            }
        }
        stage('UnitTest') {
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps {
               echo "Test the code"
            }
        }
        stage('Package') {
            steps {
               echo "Package the code ${params.Env}"
            }
        }
        stage('DEPLOY') {
            input{
                message "Select the version to deploy"
                ok "Version Selected"
                parameters{
                    choice(name:'PLATFORM',choices:['EKS','ONPREM_K8s','SERVERS'])
                }
            }
            steps {
               echo "DEPLOY the code ${params.Env}"
            }
        }
    }
}