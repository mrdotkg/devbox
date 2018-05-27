#! /usr/bin/env bash

###
#
# provision.sh
#
# This script assumes your Vagrantfile has been configured to map the root of
# your applications to /vagrant and that your web root is the "public" folder
# (Laravel standard).  Standard and error output is sent to
# /vagrant/vm_build.log during provisioning.
#
###

# Variables
DBHOST=localhost
DBNAME=db
DBUSER=root
DBPASSWD=mysql

echo -e "\n--- Okay, installing now... ---\n"

echo -e "\n--- Updating packages list ---\n"
apt-get -qq update

echo -e "\n--- Install base packages ---\n"
apt-get -y install vim curl build-essential python-software-properties git

echo -e "\n--- Install virtualbox guest addition and swapspace ---\n"
apt-get install -y virtualbox-guest-dkms virtualbox-guest-x11
sudo apt-get install -y swapspace

echo -e "\n--- Install docker ---\n"
#curl -fsSL https://download.docker.com/linux/vagrant/gpg | sudo apt-key add -
#add-apt-repository \
#   "deb [arch=amd64] https://download.docker.com/linux/vagrant \
#   $(lsb_release -cs) \
#   stable"
#apt-get update
#apt-get install -y docker-ce

# Alternatively you can use the official docker install script
curl -fsSL https://get.docker.com/ | sh
docker --version

echo -e "\n--- Install docker compose---\n"
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo -e "\n--- Install docker cleanup script ---\n"
cd /tmp
git clone https://gist.github.com/76b450a0c986e576e98b.git
cd 76b450a0c986e576e98b
mv docker-cleanup /usr/local/bin/docker-cleanup
chmod +x /usr/local/bin/docker-cleanup

echo -e "\n--- Add vagrant user to docker group ---\n"
sudo groupadd docker
usermod -a -G docker $(whoami)
sudo service docker restart

echo -e "\n--- Install Samba ---\n"
apt-get install -y samba samba-common python-glade2 system-config-samba

echo -e "\n--- Add Node 6.x rather than 4 ---\n"
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

echo -e "\n--- Updating packages list ---\n"
apt-get -qq update

# MySQL setup for development purposes ONLY
echo -e "\n--- Install MySQL specific packages and settings ---\n"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
apt-get -y install mysql-server phpmyadmin

echo -e "\n--- Installing PHP-specific packages ---\n"
apt-get -y install php apache2 libapache2-mod-php php-curl php-gd php-mysql php-gettext

echo -e "\n--- Enabling mod-rewrite ---\n"
a2enmod rewrite

echo -e "\n--- Allowing Apache override to all ---\n"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf


echo -e "\n--- We definitly need to see the PHP errors, turning them on ---\n"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini

echo -e "\n--- Restarting Apache ---\n"
service apache2 restart

echo -e "\n--- Installing Composer for PHP package management ---\n"
curl --silent https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo -e "\n--- Installing NodeJS and NPM ---\n"
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get -y update
apt-get -y install nodejs npm

echo -e "\n--- Installing javascript components ---\n"
npm install -g gulp bower
