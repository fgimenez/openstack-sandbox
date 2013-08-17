#!/bin/bash -e
echo 'Downloading client files...'
rm -rf ./client && mkdir client && cd client
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null openstack@172.16.0.2:nova.zip . && unzip nova.zip
echo 'Installing nova client packages and cloud utils...'
sudo apt-get install -y euca2ools python-novaclient unzip cloud-utils
echo 'Creating environment variables...'
. novarc
echo 'Creating client ssh keypair...'
nova keypair-delete openstack
rm -rf ./openstack.pem && nova keypair-add openstack > openstack.pem && chmod 0600 *.pem
echo 'Done!'
