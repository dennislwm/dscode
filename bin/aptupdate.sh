#!/bin/bash
#
echo 'Waiting for boot to finish...'
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
    sleep 1
done

#
# Ubuntu daily automation can lock apt-get
# sudo apt-get remove unattended-upgrades
#echo 'Remove unattended-upgrades...'
#until [[ -z $(fuser /var/lib/dpkg/lock) ]]; do
#    sleep 1
#done
#sudo apt-get remove --assume-yes unattended-upgrades

echo 'Update apt...'
until [[ -z $(fuser /var/lib/dpkg/lock) ]]; do
    sleep 1
done
sudo apt-get update

#
# Ubuntu daily automation can lock apt-get
echo 'Install packages...'
until [[ -z $(fuser /var/lib/dpkg/lock) ]]; do
    sleep 1
done
sudo apt-get install --assume-yes php7.2-cli php7.2-mysql php7.2-xml
