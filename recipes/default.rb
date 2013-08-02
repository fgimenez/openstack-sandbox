#
# Cookbook Name:: openstack-sandbox
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#             

include_recipe "apt"
include_recipe "mysql::server"
include_recipe "openstack-sandbox::users"
include_recipe "openstack-sandbox::dependencies"
include_recipe "openstack-sandbox::configuration"
include_recipe "openstack-sandbox::nova"
