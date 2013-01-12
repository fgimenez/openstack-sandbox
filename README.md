The purpose is setting up an openstack sandbox environment with a chef provisioned Vagrant box.

Add ubuntu box with: 

    $ vagrant box add ubuntu-1204-amd64 http://dl.dropbox.com/u/1537815/precise64.box

Create public and private networks:

    $ VBoxManage hostonlyif create
    $ VBoxManage hostonlyif ipconfig vboxnet0 --ip 172.16.0.254 --netmask 255.255.0.0
    $ VBoxManage hostonlyif create
    $ VBoxManage hostonlyif ipconfig vboxnet1 --ip 10.0.0.254 --netmask 255.0.0.0


