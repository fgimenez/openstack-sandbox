# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "openstack-sandbox"

  config.vm.box = "canonical-ubuntu-12.04"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

  # Ensure Chef is installed for provisioning
  config.omnibus.chef_version = :latest

  config.vm.provider :virtualbox do |vb|
    # Give enough horsepower to build without taking all day.                                                                                                          
    vb.customize [
                  "modifyvm", :id,
                  "--memory", "2048",
                  "--cpus", "2",
                 ]
  end
  
  # adapters
  config.vm.network :private_network, ip: "172.16.0.2"
  config.vm.network :private_network, ip: "10.0.0.2"

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      "recipe[openstack-sandbox::default]"
    ]
  end
end
