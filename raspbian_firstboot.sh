#!/bin/bash

# Regenerate SSH Host Keys, restart SSHd
rm /etc/ssh/ssh_host_* && dpkg-reconfigure openssh-server

# Update apt-repo
apt-get update

# Install & configure NTP
apt-get -y install ntp fake-hwclock vim
echo "Europe/Berlin" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

#
# Change hostname to openhab
#
hostname openhab
echo openhab > /etc/hostname
echo "127.0.0.1 openhab" >> /etc/hosts