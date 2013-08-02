gem_package "ruby-shadow"

ruby_block "require shadow library" do
  block do
    Gem.clear_paths  # <-- Necessary to ensure that the new library is found
    require 'shadow' # <-- gem is 'ruby-shadow', but library is 'shadow'
  end
end

user node['openstack_sandbox']['user_name'] do
  comment "Openstack User"
  gid "users"
  home "/home/openstack"
  shell "/bin/sh"
  # password: openstack
  password "$1$Rt1w56fu$0ELnxGlSofIvZ2OtowS4B."
end
