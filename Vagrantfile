# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  ## Configuration

  # Virtualbox tweaks. See http://docs.vagrantup.com/v2/virtualbox/configuration.html
  config.vm.provider :virtualbox do |vb|
    # More memory
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end


  ##  Network shares.   
  
  # UNIX users can use the nfs switch
  config.vm.synced_folder ".", "/var/www", :nfs => true
  
  # Windows users SHOULD default to the following settings - See http://docs.vagrantup.com/v2/synced-folders/nfs.html
  # config.vm.synced_folder ".", "/var/www"
  

  ## Provision

  # scripts/provision.sh will provision the box
  config.vm.provision :shell, :inline => "
    sh /vagrant/scripts/provision.sh;
  "


  ## The Vagrant Box

  # Defines the Vagrant box name, download URL, IP and hostname
  config.vm.define :vagrant do |vagrant|
    vagrant.vm.box = "precise64-apache2-xdebug-solr"
    # The following box is stored on a server of mine, feel free to use it directly.
    # If you want to rebuild it, check the source repo: https://github.com/rcuny/vagrant-apache2-xdebug-solr
    vagrant.vm.box_url = "http://rcuny.li/1dzKD4H"
    vagrant.vm.network :private_network, ip: "192.168.66.6"
    vagrant.vm.hostname = "vagrant.dcl"
  end
end
