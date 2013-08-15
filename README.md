[![Build Status](https://travis-ci.org/fgimenez/openstack-sandbox.png)](https://travis-ci.org/fgimenez/openstack-sandbox)

The purpose is setting up an openstack sandbox environment with a chef provisioned Vagrant box. This has been tested in a Debian Wheezy host machine with backports repository enabled.

Requirements
------------

The minimun requirements are a working installation of both virtualbox and vagrant. You should also have a ruby runtime, for installing the required gems with bundler:

    $ bundle install

Once this is done, you can install the required vagrant plugins:

    $ vagrant plugin bundle

You should also need two HostOnly interfaces:

    $ VBoxManage hostonlyif create
    $ VBoxManage hostonlyif ipconfig vboxnet0 --ip 172.16.0.254 --netmask 255.255.0.0
    $ VBoxManage hostonlyif create
    $ VBoxManage hostonlyif ipconfig vboxnet1 --ip 10.0.0.254 --netmask 255.0.0.0

The interface names vboxnet0 and vboxnet1 should be different if you have those names previously defined (i.e. vboxnet2 and vboxnet3).

Usage
-----

First of all, you should get the main machine up:

    $ vagrant up

Once the environment is installed, a zipped file with the required credential files to access the default project is also generated, you should copy it to the host machine via scp (user openstack has 'openstack' as password by default):
  
    $ mkdir client && cd client
    $ scp openstack@172.16.0.2:nova.zip . && unzip nova.zip
    
Then install the required packages on the host machine:

    $ sudo apt-get install -y euca2ools python-novaclient unzip cloud-utils

It is time to generate the keypair that gives us access to the cloud instances:

    $ . novarc
    $ nova keypair-add openstack > openstack.pem && chmod 0600 *.pem

Now we can get a prebuilt ubuntu UEC image to be used by our openstack environment:

    $ wget http://uec-images.ubuntu.com/releases/quantal/release/ubuntu-12.10-server-cloudimg-i386.tar.gz

and then upload it to the server:

    $ cloud-publish-tarball ubuntu-12.10-server-cloudimg-i386.tar.gz images i386

We can check that all went good listing the images:

    $ nova image-list

The ID of the .img will be used later for refering the cloud image.

Finally, after creating the default security settings that define the access rights for sshing and pinging:

    $ nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
    $ nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0

we can spin up the instaqnce with the previous listed ID:

    $ nova boot myInstance --image $ID --flavor 2 --key_name openstack

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

License and Authors
-------------------
MIT License

Authors: Federico Gimenez Nieto <federico.gimenez@gmail.com>
