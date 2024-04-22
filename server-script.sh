#! /bin/bash

#sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
#sudo yum install maven -y
sudo yum install docker -y
sudo systemctl start docker

if [ -d "addressbook" ]
then
   echo "repo is already cloned and exists"
   cd /home/ec2-user/addressbook
   git pull origin april-tf
else
   git clone https://github.com/tanujagadireddy/addressbook.git
   cd addressbook
   git checkout april-tf
fi

#mvn package
sudo docker build -t $1:$2 /home/ec2-user/addressbook
