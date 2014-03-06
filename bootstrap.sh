#!/bin/bash -e
bundle

vagrant plugin install vagrant-omnibus
vagrant plugin install vagrant-berkshelf

vagrant up

. ./bootstrap/nova.sh

. ./bootstrap/keystone.sh
