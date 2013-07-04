require_relative 'spec_helper'

describe 'openstack-sandbox::configuration' do
  let(:runner) { ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04').
    converge('openstack-sandbox::configuration')}

  context 'ntp' do
    it_behaves_like "config file creator", '/etc/ntp.conf',
                                           'server ntp.ubuntu.com',
                                           0644
  end
end
