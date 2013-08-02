require_relative 'spec_helper'

describe 'openstack-sandbox::configuration' do
  let(:mysql_root_password) {'root_password'}
  let(:mysql_user_name) {'user_name'}
  let(:mysql_user_password) {'user_password'}
  let(:mysql_database_name) {'database_name'}  

  let(:runner) do
    runner = ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set['mysql']['server_root_password'] = mysql_root_password
      node.set['mysql']['default_user_name'] = mysql_user_name
      node.set['mysql']['default_user_password'] = mysql_user_password
      node.set['mysql']['default_database_name'] = mysql_database_name
    end
    runner.converge('openstack-sandbox::configuration')
  end

  context 'ntp' do
    it_behaves_like "config file creator", '/etc/ntp.conf',
                                           'server ntp.ubuntu.com',
                                           0644
  end

  context 'mysql' do
    let(:base_connection_command) {"/usr/bin/mysql -u root -p#{mysql_root_password} -D mysql -r -B -N -e"}

    it "makes the server listen for all ips" do
      expect(runner).to execute_command("sed -i 's/bind-address/#bind-address/g' " + 
        "/etc/mysql/my.cnf")
    end

    it "creates the default user" do
      expect(runner).to execute_command("#{base_connection_command} \"CREATE USER " +
       "'#{mysql_user_name}' IDENTIFIED BY '#{mysql_user_password}'\"")
    end

    it "creates the default database" do
      expect(runner).to execute_command("#{base_connection_command} \"CREATE DATABASE " +
        "#{mysql_database_name}\"")
    end

    it "grants the default user with the right permissions" do
      expect(runner).to execute_command("#{base_connection_command} \"GRANT ALL " +
        "ON #{mysql_database_name}.* to '#{mysql_user_name}'@'%'\"")
    end

    it "sets the nova password" do
      expect(runner).to execute_command("#{base_connection_command} \"SET PASSWORD FOR "  +
        "'#{mysql_user_name}'@'%' = PASSWORD('#{mysql_user_password}')\"")
    end

    it "restarts the mysqld service" do
      expect(runner).to restart_service 'mysql'
    end
  end

  context 'compute' do
    it_behaves_like "config file creator", '/etc/nova/nova.conf',
                                           '--dhcpbridge_flagfile=/etc/nova/nova.conf',
                                           0644
    it_behaves_like "config file creator", '/etc/nova/nova-compute.conf',
                                           '--libvirt_type=qemu',
                                           0644
  end
end
