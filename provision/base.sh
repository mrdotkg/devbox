#! /usr/bin/env bash

###
# base.sh
###
echo -e "\n--- Updating packages list ---\n"
apt-get update

echo -e "\n--- Install base packages ---\n"
apt-get -y install vim curl build-essential python-software-properties python-glade2 python-dev python-pip python3-dev python3-pip swapspace git

echo -e "\n--- Install virtualbox guest addition ---\n"
apt-get install -y virtualbox-guest-dkms virtualbox-guest-x11

echo -e "\n--- Install Samba ---\n"
apt-get install -y samba samba-common system-config-samba

# precaution for locale error: unsupported locale setting
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

git --version >> /home/vagrant/vm_build.log 2>&1
python --version 2>> /home/vagrant/vm_build.log
pip --version >> /home/vagrant/vm_build.log 2>&1
python3 --version >> /home/vagrant/vm_build.log 2>&1
pip3 --version >> /home/vagrant/vm_build.log 2>&1
curl --version | grep -i '^curl' >> /home/vagrant/vm_build.log 2>&1
