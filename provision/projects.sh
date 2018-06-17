#!/usr/bin/env bash


# Default "Projects" folder
mkdir -p /home/vagrant/Projects
chown vagrant:vagrant /home/vagrant/Projects

# Create a Samba share to "Projects"
echo -e "\n[Projects]\npath = /home/vagrant/Projects\nbrowsable = yes" \
        "\nguest ok = yes\nread only = no\ncreate mask = 0664\ndirectory mask = 0775" \
        "\nforce user = vagrant\nforce group = vagrant" >> "/etc/samba/smb.conf"

# Make new shells open in "Projects" folder
echo "cd /home/vagrant/Projects" >> /home/vagrant/.bashrc

# Fix "vagrant" non-standard password issue
echo "vagrant:vagrant" | sudo chpasswd

# Config. vars
HOME_DIR="/home/vagrant"
PROJECTS_DIR=$HOME_DIR"/Projects"

# Add "developer" group
groupadd -r developer --gid 9009

# Add "vagrant" user to "developer" group
usermod -a -G developer vagrant

# "Projects" directory ownership and permissions
chown -R vagrant:developer $PROJECTS_DIR
chmod -R g+s $PROJECTS_DIR

# Copy user specific configuration to local variables
DEV_FULL_NAME="#{ENV['DEV_FULL_NAME']}"
DEV_EMAIL="#{ENV['DEV_EMAIL']}"
GITHUB_USER="#{ENV['GITHUB_USER']}"
GITHUB_PASS="#{ENV['GITHUB_PASS']}"
SERVERS_DEFAULT_USER="#{ENV['SERVERS_DEFAULT_USER']}"

# Check if configuration is all set
if [[ -z "$DEV_FULL_NAME" || -z "$DEV_EMAIL" || -z "$GITHUB_USER" || -z "$GITHUB_PASS" || -z "$SERVERS_DEFAULT_USER" ]]; then
  echo "ERROR: One or more user configuration variables are missing, please verify an \".env\" file with all required values exists in the current directory .."
  exit 1
fi

# Configure SSH so it always defaults to the right user
echo -e "Host *\n  User $SERVERS_DEFAULT_USER" >> /home/vagrant/.ssh/config

# Configure Git (Github)
echo "Configuring Git client .."
git config --global user.name "$DEV_FULL_NAME"
git config --global user.email "$DEV_EMAIL"
git config --global credential.helper store
git config --global core.autocrlf input
git config --global push.default simple
ESCAPED_GITHUB_USER="${GITHUB_USER/@/%40}"
ESCAPED_GITHUB_PASS="${GITHUB_PASS/@/%40}"
echo -e "https://$ESCAPED_GITHUB_USER:$ESCAPED_GITHUB_PASS@GITHUB.org" >> /home/vagrant/.git-credentials
