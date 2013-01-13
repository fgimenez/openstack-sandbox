name             "openstack"
maintainer       "Federico Gimenez Nieto"
maintainer_email "federico.gimenez@gmail.com"
license          "Apache 2.0"
description      "Setup of openstack"
long_description "Setup of openstack"
version          "0.0.1"
recipe           "openstack-sandbox", "Setup of openstack"

%w[ubuntu debian].each do |os|
  supports os
end
