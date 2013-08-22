default['mysql']['server_debian_password'] = default['mysql']['server_root_password'] =
  default['mysql']['server_repl_password'] = 
  default['mysql']['default_user_password'] = 'openstack'
default['mysql']['default_user_name'] = default['mysql']['default_database_name'] = 'nova'
default['mysql']['keystone_user_name'] = default['mysql']['keystone_database_name'] = 'keystone'

default['openstack_sandbox']['user_name'] = 'openstack'
default['openstack_sandbox']['nova']['services'] = %w[nova-api nova-cert nova-compute 
                                                      nova-network nova-objectstore nova-scheduler]

