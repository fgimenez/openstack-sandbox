require 'chefspec'

describe 'openstack-sandbox::dependencies' do
  let(:runner) { ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04').
    converge('openstack-sandbox::dependencies')}

  it "installs the rabittmq-server package" do
    expect(runner).to install_package('rabittmq-server')
  end

  it "installs the nova-api package" do
    expect(runner).to install_package('nova-api')
  end

  it "installs the nova-objectstore package" do
    expect(runner).to install_package('nova-objectstore')
  end

  it "installs the nova-scheduler package" do
    expect(runner).to install_package('nova-scheduler')
  end

  it "installs the nova-network package" do
    expect(runner).to install_package('nova-network')
  end

  it "installs the nova-compute package" do
    expect(runner).to install_package('nova-compute')
  end

  it "installs the nova-cert package" do
    expect(runner).to install_package('nova-cert')
  end

end
