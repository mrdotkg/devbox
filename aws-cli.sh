#!/usr/bin/env bash

# AWS-CLI INSTALLER - Automated AWS CLI Installation
apt-get install -y python-dev python-pip
pip install awscli
aws --version