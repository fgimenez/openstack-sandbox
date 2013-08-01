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
    it "makes the server listen for all ips" do
      expect(runner).to execute_command("sed -i 's/127.0.0.1/0.0.0.0/g' " +
        "/etc/mysql/my.cnf")
    end

    it "creates the default database" do
      expect(runner).to execute_command("/usr/bin/mysql -u root " +
        "-p#{mysql_root_password} -D mysql -r -B -N -e \"CREATE DATABASE " +
        "'#{mysql_database_name}'\"")
    end

    it "grants the default user with the right permissions" do
      expect(runner).to execute_command("/usr/bin/mysql -u root " +
        "-p#{mysql_root_password} -D mysql -r -B -N -e \"GRANT ALL " +
        "ON #{mysql_database_name}.* to '#{mysql_user_name}'@'%'\"")
    end

    it "sets the nova password" do
      expect(runner).to execute_command("/usr/bin/mysql -u root " +
        "-p#{mysql_root_password} -D mysql -r -B -N -e \"SET PASSWORD FOR "  +
        "'#{mysql_user_name}'@'%' = PASSWORD(#{mysql_user_password})\"")
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
    it 'syncs the database' do
      expect(runner).to execute_command("nova-manage db sync")
    end

    it 'creates the private network' do
      expect(runner).to execute_command("nova-manage network create vmnet " +
        "--fixed_range_v4=10.0.0.0/8 --network_size=64 --bridge_interface=eth2")
    end

    it 'creates the public network' do
      expect(runner).to execute_command("nova-manage floating create --ip_range=172.16.1.0/24")
    end
  end
end
