#! /bin/bash
sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
sudo yum install maven -y
if [ -d "addressbook" ]
then
  echo "repo is already cloned and exists"
  git pull origin develop
else
   git clone https://github.com/preethid/addressbook.git
fi
cd /home/ec2-user/addressbook
mvn package