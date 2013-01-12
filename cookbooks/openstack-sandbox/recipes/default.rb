package "libshadow-ruby1.8"
gem "ruby-shadow"

user "openstack" do
  comment "Openstack User"
  gid "users"
  home "/home/openstack"
  shell "/bin/sh"
  # password: openstack
  password "$1$Rt1w56fu$0ELnxGlSofIvZ2OtowS4B."
end
