#!/bin/bash -e
export CLIENT_DIR=../client
export NOVA_IP=172.26.0.2

echo 'Beginning Nova boostrap...'

echo 'Downloading client files...'
rm -rf $CLIENT_DIR && mkdir $CLIENT_DIR && cd $CLIENT_DIR
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null openstack@$NOVA_IP:nova.zip . && unzip nova.zip

echo 'Installing nova client packages and cloud utils...'
sudo apt-get install -y euca2ools python-novaclient unzip cloud-utils

echo 'Creating environment variables...'
. novarc

echo 'Creating client ssh keypair...'
nova keypair-delete openstack
rm -rf ./openstack.pem && nova keypair-add openstack > openstack.pem && chmod 0600 *.pem

echo 'Nova bootstrap done!'
