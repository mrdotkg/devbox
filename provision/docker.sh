#!/usr/bin/env bash

echo -e "\n--- Install docker ---\n"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce

# Alternatively you can use the official docker install script
#curl -fsSL https://get.docker.com/ | sh

echo -e "\n--- Install docker compose---\n"
DC_LATEST=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | tail -n 1`
curl -L "https://github.com/docker/compose/releases/download/$DC_LATEST/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo -e "\n--- Install docker cleanup script ---\n"
cd /tmp
git clone https://gist.github.com/76b450a0c986e576e98b.git
cd 76b450a0c986e576e98b
sudo mv -f docker-cleanup /usr/local/bin/docker-cleanup
sudo chmod +x /usr/local/bin/docker-cleanup

echo -e "\n--- Add vagrant user to docker group ---\n"
sudo groupadd docker
sudo usermod -a -G docker $(whoami)
sudo service docker restart



echo $(docker --version) >> vm_build.log 2>&1
echo $(docker-compose --version) >> vm_build.log 2>&1
