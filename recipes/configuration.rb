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
  command "sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf"
end

base_connection_command = "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} -D mysql -r -B -N -e"
execute "create default database" do
  command "#{base_connection_command} \"CREATE DATABASE '#{node['mysql']['default_database_name']}'\""
  only_if {`#{base_connection_command} \"SHOW DATABASES LIKE '#{node['mysql']['default_database_name']}'\"`.to_i == 0 }
end

execute "grant permissions" do
  command "#{base_connection_command} \"GRANT ALL ON #{node['mysql']['default_database_name']}.* to '#{node['mysql']['default_user_name']}'@'%'\""
end

execute "set default user password" do
  command "#{base_connection_command} \"SET PASSWORD FOR '#{node['mysql']['default_user_name']}'@'%' = PASSWORD(#{node['mysql']['default_user_password']})\""
end

service "mysql" do
  action :restart
end

