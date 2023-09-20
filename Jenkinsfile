pipeline{
    agent any
    parameters{
        string(name:'Env',defaultValue:'Test',description:'env to deploy')
        booleanParam(name:'executeTests',defaultValue: true,description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])
    }


    stages{
        stage('compile'){
            steps{
                script{
                   echo "Compile the Code"
                    echo "Deploying to env: ${params.Env}"
                }
            }
        }
        stage('UnitTest'){
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps{
                script{
                    echo "Run the UnitTest Cases"
                }
            }
        }
        stage('package'){
            steps{
                script{
                    echo "Package the Code"
                    echo "Packing the code version ${params.APPVERSION}"
                }
            }
        }
    }
}