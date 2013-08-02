require_relative 'spec_helper'


describe 'openstack-sandbox::nova' do
  let(:runner) { ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04').
    converge('openstack-sandbox::nova')}

  context 'initialization' do
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

  context "cloudadmin account and project" do
    it 'creates an admin user' do
      expect(runner).to execute_command('nova-manage user admin openstack')
    end

    it 'creates adds the cloudadmin role to the admin user' do
      expect(runner).to execute_command('nova-manage role add openstack cloudadmin')
    end

    it 'creates a default project for the admin user' do
      expect(runner).to execute_command('nova-manage project create cookbook openstack')
    end

    it 'zip the files required for accessing the project' do
      expect(runner).to execute_command('nova-manage project zipfile cookbook openstack')
    end
  end
end
