#!/bin/bash


echo "updating apt-get"
sudo apt-get update

echo "installing maven"
sudo apt-get -y install maven

echo "installing ruby"
sudo apt-get -y install ruby

echo "installing ruby"
sudo apt-get -y install wget

echo "cd to /home/ubuntu/"
cd /home/ubuntu

echo "wget code deploy"
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install

echo "change code deploy permission"
chmod +x ./install

echo "installing codedeploy"
sudo ./install auto