#!/usr/bin/env bash

# AWS-CLI INSTALLER - Automated AWS CLI Installation
sudo apt-get install -y python3-dev python3-pip
pip3 install awscli --upgrade --user


echo $(aws --version) >> /home/vagrant/vm_build.log 2>&1
