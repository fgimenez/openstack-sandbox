#!/bin/bash -e
echo 'Beginning Keystone boostrap...'

echo 'Defining environment variables...'
export ENDPOINT=172.16.0.2
export SERVICE_TOKEN=ADMIN
export SERVICE_ENDPOINT=http://${ENDPOINT}:35357/v2.0

echo 'Installing keystone client packages...'
sudo apt-get install -y python-keystoneclient

echo 'Creating admin role...'
keystone role-create --name admin

echo 'Creating member role...'
keystone role-create --name Member

echo 'Keystone bootstrap done!'
