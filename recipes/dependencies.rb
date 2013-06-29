execute "apt-get update" do
  command "apt-get update"
end

package 'rabittmq-server'

package 'nova-api'

package 'nova-objectstore'

package 'nova-scheduler'

package 'nova-network'

package 'nova-compute'

package 'nova-cert'
#%w[rabbitmq-server nova-api nova-objectstore nova-scheduler nova-network nova-compute nova-cert glance qemu unzip].each do |dep| 
#  package dep
#end
