def compile() {
    echo "compiling the code..."
    sh 'mvn compile'
} 

def UnitTest() {
    echo "testing..."
    sh 'mvn test'
} 

def package() {
    echo 'packaging the application...'
  sh 'mvn package'
} 

return this
