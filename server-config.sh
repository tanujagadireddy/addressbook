#! /bin/bash
# sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
sudo yum install docker -y
sudo systemctl start docker
# sudo yum install maven -y
if [ -d "addressbook-v2" ]
then
  echo "repo is already cloned and exists"
  cd /home/ec2-user/addressbook-v2
  git pull origin cicd-docker
else
   git clone https://github.com/preethid/addressbook-v2.git
fi
cd /home/ec2-user/addressbook-v2
git checkout cicd-docker
sudo docker build -t $1:$2 /home/ec2-user/addressbook-v2