#!/bin/bash

echo "get cloud watch agent"
wget https://s3.us-east-1.amazonaws.com/amazoncloudwatch-agent-us-east-1/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

# lsof /var/lib/dpkg/lock

echo "install cloud watch agent"
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb



echo "start cloud watch agent"
sudo amazon-cloudwatch-agent-ctl -m ec2 -a start