# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.hostname = "openstack-sandbox"

  config.vm.box = "canonical-ubuntu-12.04"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

  # memory
  config.vm.customize ["modifyvm", :id, "--memory", 2048]

  # adapters
  config.vm.network :hostonly, "172.26.0.2", adapter: 2, netmask: "255.255.0.0"
  config.vm.network :hostonly, "10.0.0.2", adapter: 3, netmask: "255.0.0.0"

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port 22, 2222
  
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe "openstack-sandbox"
  end
end
