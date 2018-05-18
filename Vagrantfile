# -*- mode: ruby -*-
# vi: set ft=ruby :

# Install Vagrant plugins
unless Vagrant.has_plugin?('vagrant-reload')
  system('vagrant plugin install vagrant-reload') || exit!
  exit system('vagrant', *ARGV)
end

unless Vagrant.has_plugin?('vagrant-env')
  system('vagrant plugin install vagrant-env') || exit!
  exit system('vagrant', *ARGV)
end

unless Vagrant.has_plugin?('vagrant-disksize')
  system('vagrant plugin install vagrant-disksize') || exit!
  exit system('vagrant', *ARGV)
end

Vagrant.configure("2") do |config|
  config.env.enable
  config.vm.box = "ubuntu/xenial64"
#   config.vm.box_version = "20170822.0.0"
  
  # Host configuration
  config.vm.hostname = "ubuntu.dev"

  # Private network
  config.vm.network "private_network", ip: "192.168.33.10", bridge: "en0: Wi-Fi (AirPort)"

  # Enable ssh forward agent
  config.ssh.forward_agent = true

  # Disable default share
  config.vm.synced_folder '.', '/vagrant', disabled: true

  # Future-proof our main HD :)
#   config.disksize.size = '30GB'

  # VirtualBox specific config.
  config.vm.provider "virtualbox" do |vb|
    # VirtualBox name
    vb.name = "Ubuntu Dev"

    # Customize the amount of memory on the VM:
    vb.memory = "4096"

    # CPUs
    vb.cpus = 2

    # Customizations
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
    vb.customize ["modifyvm", :id, '--clipboard', 'bidirectional']
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end


  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", path: "provision.sh"

  config.vm.provision "shell", inline: <<-SHELL
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
  SHELL

  # Changes that require "root" permissions
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
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
  SHELL

  # Other "regular user" changes
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    # Config. vars
    HOME_DIR="/home/vagrant"
    PROJECTS_DIR=$HOME_DIR"/Projects"

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
  SHELL

   config.vm.provision "shell", path: "terraform.sh"
   config.vm.provision "shell", path: "aws-cli.sh"

 # Reload the VM
  config.vm.provision :reload

  # Build success message
  config.vm.post_up_message = "  ########################################################################################################
  ### devbox Build Completed ...                                                                       ###
  ###                                                                                                  ###
  ### TO PACKAGE THIS AS A BOX                                                                         ###
  ### ------------------------------------------------------------------------------------------------ ###
  ### VAGRANT_HOST> vagrant ssh (log into running box)                                                 ###
  ### $ sudo apt-get clean                                                                             ###
  ### $ sudo dd if=/dev/zero of=/EMPTY bs=1M                                                           ###
  ### $ sudo rm -f /EMPTY                                                                              ###
  ### $ cat /dev/null > ~/.bash_history && history -c && exit                                          ###
  ### VAGRANT_HOST> vagrant package --output developer-base-devbox.box                       ###
  ########################################################################################################
  "
end
