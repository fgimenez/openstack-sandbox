%w[rabbitmq-server nova-api nova-objectstore nova-scheduler nova-network nova-compute nova-cert glance qemu unzip ntp].each do |dep| 
  package dep
end
