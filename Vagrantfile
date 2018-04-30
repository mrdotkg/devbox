# -*- mode: ruby -*-
# vi: set ft=ruby :

# Install Vagrant plugins
unless Vagrant.has_plugin?('vagrant-reload')
  system('vagrant plugin install vagrant-reload') || exit!
  exit system('vagrant', *ARGV)
end

Vagrant.configure("2") do |config|

  # Base VM box
  config.vm.box = "TimWSpence/elementaryos"

  # Host configuration
  config.vm.hostname = "devbox"

  # Public network
  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", ip: "192.168.33.1"

  # Disable default share
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # Provision
  config.vm.provision "shell", privileged: true, inline: <<-SHELL

    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    # app-fast
    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    sudo apt-get update -y  && sudo apt-get dist-upgrade -y
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:saiarcot895/myppa
    sudo apt-get install -y apt-fast

    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    # base os cleanup
    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    sudo apt-get purge -y epiphany-browser epiphany-browser-data #browser
    sudo apt-get purge -y midori-granite #browser
    sudo apt-get purge -y noise
    sudo apt-get purge -y scratch-text-editor #text-editor
    sudo apt-get purge -y modemmanager
    sudo apt-get purge -y geary #email
    sudo apt-get purge -y pantheon-mail #email
    sudo apt-get purge -y pantheon-terminal #terminal
    sudo apt-get purge -y audience
    sudo apt-get purge -y maya-calendar #calendar

    sudo apt-get autoremove -y
    sudo apt-get autoclean -y


    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    # install os software repository items
    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    apt-fast install -y virtualbox-guest-dkms virtualbox-guest-x11
    sudo apt-fast install -y apt-transport-https ca-certificates curl
    sudo apt-fast install -y gdebi
    sudo apt-fast install -y rar unrar zip unzip p7zip-full p7zip-rar
    sudo apt-fast install -y terminator
    sudo apt-fast install -y krita
    sudo apt-fast install -y htop
    sudo apt-fast install -y gparted
    sudo apt-fast install -y flashplugin-installer vlc browser-plugin-vlc
    sudo apt-fast install -y firefox
    sudo apt-fast install -y inkscape
    sudo apt-fast install -y kazam
    sudo apt-fast install -y git
    sudo apt install openssh-server


    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    # add external software repositories
    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    # Elementry tweaks
    sudo add-apt-repository ppa:philip.scott/elementary-tweaks
    # Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     xenial \
     stable"
    sudo add-apt-repository ppa:linrunner/tlp
    # Atom
    curl -L https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'

    sudo apt-fast update -y


    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    # install external software repository items
    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    # Reduce overheating and improve battery life
    sudo apt-fast install -y tlp tlp-rdw
    sudo tlp start

    # WPS (Office Alternative)
    wget http://kdl1.cache.wps.com/ksodl/download/linux/a21//wps-office_10.1.0.5707~a21_amd64.deb
    gdebi -i wps-office_10.1.0.5672~a21_amd64.deb
    # WPS Fonts
    wget http://kdl.cc.ksosoft.com/wps-community/download/fonts/wps-office-fonts_1.0_all.deb
    gdebi -i wps-office-fonts_1.0_all.deb

    # Chrome
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    gdebi -i google-chrome-stable_current_amd64.deb
    gconftool-2 --set /apps/metacity/general/button_layout --type string ":minimize:maximize:close"

    # jenv
    curl -L -s get.jenv.io | bash
    source ~/.jenv/bin/jenv-init.sh
    jenv selfupdate

    # Elementry tweaks
    sudo apt-fast install -y elementary-tweaks elementary-wallpapers-extra

    # Docker, Docker-compose
    apt-fast install -y docker-ce
    curl -L "https://github.com/docker/compose/releases/download/1.21.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    # Docker commands auto completion
    sudo curl -L https://raw.githubusercontent.com/docker/compose/1.21.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

    # Docker Cleanup script
    cd /tmp
    git clone https://gist.github.com/76b450a0c986e576e98b.git
    cd 76b450a0c986e576e98b
    mv docker-cleanup /usr/local/bin/docker-cleanup
    chmod +x /usr/local/bin/docker-cleanup

    # Add vagrant user to docker group
    usermod -a -G docker vagrant

    # Atom
    sudo apt-fast install atom
    apm install platformio-ide-terminal

    # Teamviewer 11
    wget https://download.teamviewer.com/download/teamviewer_i386.deb
    gdebi -i teamviewer_i386.deb

    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    # development environments installation
    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    sudo apt-fast install build-essential

    # python build tools
    sudo apt-fast install -y python-dev python-pip python-virtualenv python-numpy python-matplotlib
    # pyhthon for machine learning
    pip install scipy scikit-learn matplotlib jupyter pandas numpy tensorflow keras seaborn
    # pyhthon for web development
    pip install django beautifulsoup4 requests ipython

    # networking tools
    sudo apt-fast install -y libpcap-dev libnet1-dev rpcbind openssh-server nmap

    # node
    echo 'export PATH=$HOME/local/bin:$PATH' >> ~/.bashrc
    . ~/.bashrc
    mkdir ~/local
    mkdir ~/node-latest-install
    cd ~/node-latest-install
    curl http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1
    ./configure --prefix=~/local
    make install # ok, fine, this step probably takes more than 30 seconds...
    curl https://www.npmjs.org/install.sh | sh
    npm install -g bower
    npm install -g grunt-cli

    # lamp
    sudo apt-fast install -y tasksel
    sudo tasksel install -y lamp-server
    sudo apt-fast install -y phpmyadmin

    # vhost
    curl https://gist.github.com/fideloper/2710970/raw/5d7efd74628a1e3261707056604c99d7747fe37d/vhost.sh > vhost
    sudo chmod guo+x vhost
    sudo mv vhost /usr/local/bin

    # composer
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer

    # samba

    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    # development environments configuration
    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

    # git
    touch ~/.gitignore_global
    git config --global core.excludesfile ~/.gitignore_global
    git config --global user.name "Kumar Gaurav"
    git config --global user.email "grv.rkg@gmail.com"

    ssh-keygen -t rsa -C "grv.rkg@gmail.com"
    cat ~/.ssh/id_rsa.pub
    # php
    # apache
    sudo apache2ctl restart
    # mysql
    # samba


    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    # fix broken dependencies
    # +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    sudo apt-fast install -y -f
  SHELL

  # VirtualBox specific config.
  config.vm.provider "virtualbox" do |vb|
    # VirtualBox name
    vb.name = "DevBox"

    # Display the VirtualBox GUI when booting the machine
    vb.gui = true

    # Customize the amount of memory on the VM:
    vb.memory = "4096"

    # CPUs
    vb.cpus = 2

    # Customizations
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
    vb.customize ["modifyvm", :id, '--clipboard', 'bidirectional']
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  # Reload the VM
  config.vm.provision :reload

  # Build success message
  config.vm.post_up_message = "################ DEVBOX BUILD COMLPETE ################"
end
