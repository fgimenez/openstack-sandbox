[![Build Status](https://travis-ci.org/fgimenez/openstack-sandbox.png)](https://travis-ci.org/fgimenez/openstack-sandbox)

The purpose is setting up an openstack sandbox environment with a chef provisioned Vagrant box. This has been tested in a Debian Wheezy host machine with backports repository enabled.

Requirements
------------

The minimun requirements are a working installation of both virtualbox and vagrant (1.2+). You should also have a ruby runtime

Usage
-----

First of all, you should bootstrap the environment (you should use the openstack user password, 'openstack', and your root password to install nova client packages): 
  
    $ ./bootstrap.sh

Now you can get a prebuilt ubuntu UEC image to be used by the openstack environment:

    $ wget http://uec-images.ubuntu.com/releases/quantal/release/ubuntu-12.10-server-cloudimg-i386.tar.gz

and then upload it to the server:

    $ cloud-publish-tarball ubuntu-12.10-server-cloudimg-i386.tar.gz images i386

You can check that all went good listing the images:

    $ nova image-list

The ID of the .img will be used later for refering the cloud image.

Finally, after creating the default security settings that define the access rights for sshing and pinging:

    $ nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
    $ nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0

you can spin up the instaqnce with the previous listed ID:

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


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/fgimenez/openstack-sandbox/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

