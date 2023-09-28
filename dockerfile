From tomcat:8.5.72-jdk8-openjdk-buster

Env MAVEN_HOME /usr/share/maven
Env MAVEN_VERSION 3.8.4

WORKDIR /app


RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share && \
    mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    apt-get clean

copy ./pom.xml ./pom.xml

copy ./src ./src

run mvn package

Run cp /app/target/addressbook.war /usr/local/tomcat/webapps/

expose 8080

CMD ["catalina.sh", "run"]