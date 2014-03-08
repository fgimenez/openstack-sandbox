require_relative 'spec_helper'

describe 'openstack-sandbox::default' do
  let(:runner) { ChefSpec::Runner.new.converge('openstack-sandbox::default')}

  before(:each) do
    stub_command("\"/usr/bin/mysql\" -u root -e 'show databases;'").and_return(false)
    stub_command("nova-manage network list | grep 10.0.0.0/").and_return(false)
    stub_command("nova-manage user list | grep openstack").and_return(false)
    stub_command("nova-manage role has openstack cloudadmin | grep True").and_return(false)
    stub_command("nova-manage project list | grep cookbook").and_return(false)
  end

  %w(apt mysql::server openstack-sandbox::users openstack-sandbox::dependencies
openstack-sandbox::configuration openstack-sandbox::nova).each do |recipe|
    it "includes the #{recipe} recipe" do
      expect(runner).to include_recipe(recipe)
    end
  end

end
