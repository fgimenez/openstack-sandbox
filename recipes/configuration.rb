# ntp
cookbook_file '/etc/ntp.conf' do
  source 'ntp_cfg'
  owner 'root'
  group 'root'
  mode 0644
  action :create
end

#mysql
execute "make mysql server listen on all ips" do
  command "sed -i 's/^bind-address/#bind-address/g' /etc/mysql/my.cnf"
end

base_connection_command = "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e"

=begin
execute "create default user" do
  command "#{base_connection_command} \"CREATE USER '#{node['mysql']['default_user_name']}' IDENTIFIED BY '#{node['mysql']['default_user_password']}'\""
  not_if "#{base_connection_command} \"SELECT COUNT(*) FROM user where User='#{node['mysql']['default_user_name']}'\""
end
=end

execute "create default database" do
  command "#{base_connection_command} \"CREATE DATABASE IF NOT EXISTS #{node['mysql']['default_database_name']}\""
end

execute "grant permissions and create user" do
  command "#{base_connection_command} \"GRANT ALL ON #{node['mysql']['default_database_name']}.* to '#{node['mysql']['default_user_name']}'@'%' IDENTIFIED BY '#{node['mysql']['default_user_password']}'\""
end

execute "set default user password" do
  command "#{base_connection_command} \"SET PASSWORD FOR '#{node['mysql']['default_user_name']}'@'%' = PASSWORD('#{node['mysql']['default_user_password']}')\""
end

service "mysql" do
  action :restart
end

#keystone
=begin
execute "create keystone user" do
  command "#{base_connection_command} \"CREATE USER '#{node['mysql']['keystone_user_name']}' IDENTIFIED BY '#{node['mysql']['default_user_password']}'\""
  not_if "#{base_connection_command} \"SELECT COUNT(*) FROM user where User='#{node['mysql']['keystone_user_name']}'\""
end
=end

execute "create keystone database" do
  command "#{base_connection_command} \"CREATE DATABASE IF NOT EXISTS #{node['mysql']['keystone_database_name']}\""
end

execute "grant keystone permissions and create user" do
  command "#{base_connection_command} \"GRANT ALL ON #{node['mysql']['keystone_database_name']}.* to '#{node['mysql']['keystone_user_name']}'@'%' IDENTIFIED BY '#{node['mysql']['default_user_password']}'\""
end

execute "keystone configuration file" do
  command "sed -i \"s#^connection.*#connection =mysql://#{node['mysql']['keystone_user_name']}:" +
    "#{node['mysql']['default_user_password']}@#{node['openstack_sandbox']['host_ip']}/#{node['mysql']['keystone_database_name']}#\"" +
    " /etc/keystone/keystone.conf"
end

service "keystone" do
  action :restart
end

execute "sync keystone required dbs" do
  command "keystone-manage db_sync"
end

#compute
cookbook_file '/etc/nova/nova.conf' do
  source 'nova_cfg'
  owner 'root'
  group 'root'
  mode 0644
  action :create
end

cookbook_file '/etc/nova/nova-compute.conf' do
  source 'nova_compute_cfg'
  owner 'root'
  group 'root'
  mode 0644
  action :create
end
