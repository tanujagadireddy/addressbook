#! /bin/bash
# sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
sudo yum install docker -y
sudo systemctl start docker
# sudo yum install maven -y
if [ -d "addressbook" ]
then
  echo "repo is already cloned and exists"
  cd /home/ec2-user/addressbook
  git pull origin cicd-docker
else
   git clone https://github.com/preethid/addressbook.git
fi
#cd /home/ec2-user/addressbook-v2
cd /home/ec2-user/addressbook
git checkout cicd-k8s
sudo docker build -t $1:$2 /home/ec2-user/addressbook