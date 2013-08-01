require_relative 'spec_helper'

describe 'openstack-sandbox::default' do
  let(:runner) { ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04').
    converge('openstack-sandbox::default')}

  it 'includes the apt recipe' do
    expect(runner).to include_recipe('apt')
  end

  it 'includes the mysql::server recipe' do
    expect(runner).to include_recipe('mysql::server')
  end

  it 'includes the openstack-sandbox::users recipe' do
    expect(runner).to include_recipe('openstack-sandbox::users')
  end

  it 'includes the openstack-sandbox::dependencies recipe' do
    expect(runner).to include_recipe('openstack-sandbox::dependencies')
  end

  it 'includes the openstack-sandbox::configuration recipe' do
    expect(runner).to include_recipe('openstack-sandbox::configuration')
  end

end
