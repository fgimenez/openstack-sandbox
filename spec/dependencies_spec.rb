require 'chefspec'

describe 'openstack-sandbox::dependencies' do
  let(:runner) { ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04').
    converge('openstack-sandbox::dependencies')}

  it "installs the rabittmq-server package" do
    expect(runner).to install_package('rabittmq-server')
  end
end
