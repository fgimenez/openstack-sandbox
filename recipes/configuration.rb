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
  command "sed -i 's/bind-address/#bind-address/g' /etc/mysql/my.cnf"
  only_if {`grep \#bind-address /etc/mysql/my.cnf`.to_i == 0}
end

base_connection_command = "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e"
execute "create default user" do
  command "#{base_connection_command} \"CREATE USER '#{node['mysql']['default_user_name']}' IDENTIFIED BY '#{node['mysql']['default_user_password']}'\""
  only_if {`#{base_connection_command} \"SELECT COUNT(*) FROM user where User='#{node['mysql']['default_user_name']}'\"`.to_i == 0 }
end

execute "create default database" do
  command "#{base_connection_command} \"CREATE DATABASE #{node['mysql']['default_database_name']}\""
  only_if {`#{base_connection_command} \"SHOW DATABASES LIKE '#{node['mysql']['default_database_name']}'\"`.to_i == 0 }
end

execute "grant permissions" do
  command "#{base_connection_command} \"GRANT ALL ON #{node['mysql']['default_database_name']}.* to '#{node['mysql']['default_user_name']}'@'%'\""
end

execute "set default user password" do
  command "#{base_connection_command} \"SET PASSWORD FOR '#{node['mysql']['default_user_name']}'@'%' = PASSWORD('#{node['mysql']['default_user_password']}')\""
end

service "mysql" do
  action :restart
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

