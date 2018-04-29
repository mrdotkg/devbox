# -*- mode: ruby -*-
# vi: set ft=ruby :

# Install Vagrant plugins
unless Vagrant.has_plugin?('vagrant-reload')
  system('vagrant plugin install vagrant-reload') || exit!
  exit system('vagrant', *ARGV)
end

unless Vagrant.has_plugin?('vagrant-disksize')
  system('vagrant plugin install vagrant-disksize') || exit!
  exit system('vagrant', *ARGV)
end

Vagrant.configure("2") do |config|

  # Base VM box
  config.vm.box = "TimWSpence/elementaryos"

  # Host configuration
  config.vm.hostname = "devbox"

  # Public network
  config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)"

  # Disable default share
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # Future-proof our main HD :)
  config.disksize.size = '20GB'

  # Provision
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    # First you update your system
    sudo apt-get update -y  && sudo apt-get dist-upgrade -y

    # Clean-up System
    sudo apt-get purge -y epiphany-browser epiphany-browser-data #browser
    sudo apt-get purge -y midori-granite #browser
    sudo apt-get purge -y noise
    sudo apt-get purge -y scratch-text-editor #text-editor
    sudo apt-get purge -y modemmanager
    sudo apt-get purge -y geary #email
    sudo apt-get purge -y pantheon-mail #email
    # sudo apt-get purge -y pantheon-terminal #terminal
    sudo apt-get purge -y audience
    sudo apt-get purge -y maya-calendar #calendar

    sudo apt-get autoremove -y
    sudo apt-get autoclean -y

    # Properties Commons (to install elementary tweaks
    sudo apt-get install -y software-properties-common
    # For ubuntu packages
    sudo apt-get install -y gdebi
    # Terminator
    # sudo apt-get install -y terminator
    #Install File Compression Libs
    sudo apt-get install -y rar unrar zip unzip p7zip-full p7zip-rar
    # krita
    sudo apt-get install -y krita
    # GIT
    sudo apt-get install -y git
    # HTOP
    sudo apt-get install -y htop
    # GParted
    sudo apt-get install -y gparted
    # VLC
    sudo apt-get install -y vlc browser-plugin-vlc
    # FireFox
    sudo apt-get install -y firefox
    # InkScape
    sudo apt-get install -y inkscape
    # Kazam
    sudo apt-get install -y kazam
    # OpenSSH
    sudo apt install openssh-server
    # GUI OpenVPN
    sudo apt-get install -y network-manager-openvpn
    sudo restart network-manager
    # WPS (Office Alternative)
    wget http://kdl1.cache.wps.com/ksodl/download/linux/a21//wps-office_10.1.0.5707~a21_amd64.deb
    gdebi -i wps-office_10.1.0.5672~a21_amd64.deb

    # WPS Fonts
    wget http://kdl.cc.ksosoft.com/wps-community/download/fonts/wps-office-fonts_1.0_all.deb
    gdebi -i wps-office-fonts_1.0_all.deb

    # Elementary Tweak
    ## 1. adding repository
    sudo add-apt-repository ppa:philip.scott/elementary-tweaks
    ## 2. updating apt-get
    sudo apt-get update -y
    ## 3. installing tweaks
    sudo apt-get install -y elementary-tweaks
    ## 4. installing wallpapers
    sudo apt-get install -y elementary-wallpapers-extra

    # Google Chrome
    # 1. downloading last stable package
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    # 2. installing package
    gdebi -i google-chrome-stable_current_amd64.deb
    # 3. fixing broken dependencies
    sudo apt-get install -y -f
    # 4. Enable maximize and minimize button on Google Chrome
    gconftool-2 --set /apps/metacity/general/button_layout --type string ":minimize:maximize:close"

    # JEnv
    ## 1. Downloading and installing package
    curl -L -s get.jenv.io | bash
    ## 2. updating bash
    source ~/.jenv/bin/jenv-init.sh
    ## 3. update jenv local repository
    jenv selfupdate

    #Install Spotify
    ## 1. Add the Spotify repository signing key to be able to verify downloaded packages
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
    ## 2. Add the Spotify repository
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
    ## 3. Update list of available packages
    sudo apt-get update -y
    ## 4. Install Spotify
    sudo apt-get install -y spotify-client

    # Install Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
    apt-get update
    apt-get install -y docker-ce
    # Install Docker Compose
    curl -L "https://github.com/docker/compose/releases/download/1.21.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    # Install docker commands auto completion
    sudo curl -L https://raw.githubusercontent.com/docker/compose/1.21.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
    # Install Docker Cleanup script
    cd /tmp
    git clone https://gist.github.com/76b450a0c986e576e98b.git
    cd 76b450a0c986e576e98b
    mv docker-cleanup /usr/local/bin/docker-cleanup
    chmod +x /usr/local/bin/docker-cleanup
    # Add vagrant user to docker group
    usermod -a -G docker vagrant


    # # VirtualBox
    # ## 1. downloading package
    # wget http://download.virtualbox.org/virtualbox/5.1.6/VirtualBox-5.1.6-110634-Linux_amd64.run
    # ## 2. installing package into /opt
    # sudo sh VirtualBox-5.1.6-110634-Linux_amd64.run
    # ## 3. downloading extension pack
    # wget http://download.virtualbox.org/virtualbox/5.1.6/Oracle_VM_VirtualBox_Extension_Pack-5.1.6-110634.vbox-extpack
    # ## 4. install extension pack
    # sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.1.6-110634.vbox-extpack
    # ## 5. listing installed extension packs
    # sudo VBoxManage list extpacks

    # # Sublime Text 3
    # ## 1. downloading package
    # wget https://download.sublimetext.com/sublime-text_build-3126_amd64.deb
    # ## 2. installing package
    # gdebi -i sublime-text_build-3126_amd64.deb
    # ## 3. fixing broken dependencies
    # sudo apt-get install -y -f

    # Atom: add atom official ppa to apt-get
    curl -L https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
    sudo apt-get update
    # Install Atom
    sudo apt-get install atom
    # Install atom plugin packages
    apm install platformio-ide-terminal

    ## Teamviewer 11
    ## 1. downloading package
    #wget https://download.teamviewer.com/download/teamviewer_i386.deb
    ## 2. installing package
    #gdebi -i teamviewer_i386.deb
    ## 3. fixing broken dependencies
    #sudo apt-get install -y -f

    # ## SmartGIT
    # ## 1. downloading package
    # wget http://www.syntevo.com/smartgit/download?file=smartgit/smartgit-8_0_1.deb
    # ## 2. installing package
    # gdebi -i smartgit-8_0_1.deb
    # ## 3. fixing broken dependencies
    # sudo apt-get install -y -f

    # Elementary Transparent Theme
    ## 1. adding repository
    sudo add-apt-repository ppa:yunnxx/elementary
    ## 2. updating apt-get
    sudo apt-get update -y
    ## 3. installing transparent theme
    sudo apt-get install -y elementary-transparent-theme

    #Reduce overheating and improve battery life
    ## 1. adding repository
    sudo add-apt-repository ppa:linrunner/tlp
    ## 2. updating apt-get
    sudo apt-get update -y
    ## 3. installing package
    sudo apt-get install -y tlp tlp-rdw
    ## 4. starting application
    sudo tlp start

    # Install Samba
    apt-get install -y samba samba-common python-glade2 system-config-samba
    # Default "Projects" folder
    mkdir -p /home/vagrant/Projects
    chown vagrant:vagrant /home/vagrant/Projects
    # Create a Samba share to "Projects"
    echo -e "\n[Projects]\npath = /home/vagrant/Projects\nbrowsable = yes" \
            "\nguest ok = yes\nread only = no\ncreate mask = 0664\ndirectory mask = 0775" \
            "\nforce user = vagrant\nforce group = vagrant" >> "/etc/samba/smb.conf"

    # Handle 100% CPU Usage
    sudo chmod 744 /usr/lib/gvfs/gvfsd-smb-browse

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
