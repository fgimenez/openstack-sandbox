require_relative 'spec_helper'

describe 'openstack-sandbox::users' do
  let(:user_name) {'user_name'}

  let(:runner) do
    runner = ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04') do |node|
      node.set['openstack_sandbox']['user_name'] = user_name
    end
    runner.converge('openstack-sandbox::users')
  end

  it 'creates the default user' do
    expect(runner).to create_user(user_name)
  end
end
