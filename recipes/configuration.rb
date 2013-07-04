# ntp
cookbook_file '/etc/ntp.conf' do
  source 'ntp_cfg'
  owner 'root'
  group 'root'
  mode 0644
  action :create
end

