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

Vagrant.configure("2") do |config|
  config.env.enable
  config.vm.box = "ubuntu/xenial64"

  # Host configuration
  config.vm.hostname = "devbox"

  # Private network
  config.vm.network "private_network", ip: "192.168.33.10", bridge: "en0: Wi-Fi (AirPort)"

  # Enable ssh forward agent
  config.ssh.forward_agent = true

  # Disable default share
  config.vm.synced_folder 'provision', '/home/vagrant/workspace', type: 'nfs', mount_options: ['rw','vers=3','tcp'], linux__nfs_options:['rw','no_subtree_check','all_squash','async']

  # VirtualBox specific config.
  config.vm.provider "virtualbox" do |vb|
    # VirtualBox name
    vb.name = "Devbox"

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
  config.vm.provision "shell", path: "provision/base.sh"

  # Changes that require "root" permissions
  config.vm.provision "shell", privileged: true,path: "provision/projects.sh"

  # Comment the lines below to stop them from being provisioned
  config.vm.provision "shell", path: "provision/pamp.sh"
  config.vm.provision "shell", path: "provision/node.sh"
  config.vm.provision "shell", path: "provision/docker.sh"
  config.vm.provision "shell", path: "provision/aws-cli.sh"
  config.vm.provision "shell", path: "provision/terraform.sh"

  # Reload the VM
  config.vm.provision :reload

  # Build success message
  config.vm.post_up_message = "  ########################################################################################################
  ### Devbox Build Completed ...                                                                       ###
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