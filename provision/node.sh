#!/usr/bin/env bash

echo -e "\n--- Installing NodeJS and NPM ---\n"
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs


echo -e "\n--- Installing javascript components ---\n"
npm install -g gulp bower


echo nodejs $(nodejs --version) >> vm_build.log 2>&1
echo npm $(npm --version) >> vm_build.log 2>&1
echo bower $(bower --version) >> vm_build.log 2>&1
echo gulp $(gulp --version) >> vm_build.log 2>&1