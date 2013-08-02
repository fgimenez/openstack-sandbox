#
execute "sync database" do
  command 'nova-manage db sync'
end

execute "create private network" do
  command "nova-manage network create vmnet " +
    "--fixed_range_v4=10.0.0.0/8 --network_size=64 --bridge_interface=eth2"
end

execute "create public network" do
  command 'nova-manage floating create --ip_range=172.16.1.0/24'
end
