#!/usr/bin/env bash

# Variables
DBHOST=localhost
DBNAME=db
DBUSER=root
DBPASSWD=mysql

# MySQL setup for development purposes ONLY
echo -e "\n--- Install MySQL specific packages and settings ---\n"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
sudo apt-get -y install mysql-server phpmyadmin
sudo ln -s /usr/share/phpmyadmin/ /var/www/html/phpmyadmin

echo -e "\n--- Installing PHP-specific packages ---\n"
sudo apt-get -y install php apache2 libapache2-mod-php php-curl php-gd php-mysql php-gettext
sudo apt-get -y install php-mbstring php7.0-mbstring php-gettext libapache2-mod-php7.0
sudo phpenmod mcrypt
sudo phpenmod mbstring

echo -e "\n--- Enabling mod-rewrite ---\n"
a2enmod rewrite

echo -e "\n--- Allowing Apache override to all ---\n"
sudo sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf


echo -e "\n--- We definitly need to see the PHP errors, turning them on ---\n"
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini

echo -e "\n--- Restarting Apache ---\n"
sudo service apache2 restart

echo -e "\n--- Installing Composer for PHP package management ---\n"
curl --silent https://getcomposer.org/installer | php
sudo mv -f composer.phar /usr/local/bin/composer

echo $(php -v | grep -i '^php') >> vm_build.log 2>&1
echo $(apache2 -v) >> vm_build.log 2>&1
echo $(mysql --version) >> vm_build.log 2>&1
dpkg --list | grep -i phpmyadmin >> vm_build.log 2>&1
