#!/bin/bash

ADDONS=$(pwd)/addons

#
# Prepare for openHAB, create openhab-user
#
id openhab 2>/dev/null >/dev/null || useradd -c openHAB -d /home/openhab -m -U openhab

#
# Slim down image
#
aptitude update
aptitude purge xserver-xorg xserver-xorg-core x11-common lxde
apt-get autoremove
aptitude upgrade

#
# Java: Download && install
#
wget --no-check-certificate http://www.java.net/download/JavaFXarm/jdk-8-ea-b36e-linux-arm-hflt-29_nov_2012.tar.gz
mkdir -p /opt
tar zxvf jdk-8-ea* -C /opt
rm jdk-8-ea*
ln -snf /opt/jdk1.8.0/jre/bin/java /usr/bin/java
java -version

#
# Download openhab, setup
#
cd /home/openhab
# Donwload & extract
https://openhab.ci.cloudbees.com/job/openHAB/lastSuccessfulBuild/artifact/distribution/target/distribution-1.3.0-SNAPSHOT-runtime.zip
https://openhab.ci.cloudbees.com/job/openHAB/lastSuccessfulBuild/artifact/distribution/target/distribution-1.3.0-SNAPSHOT-demo.zip
unzip openhab-runtime-*.zip
unzip -o openhab-demo-*.zip
rm -v *.zip
rm -v addons/*tts*
DATE=$(date +%Y%m%d)
mkdir runtime-$DATE
mv * runtime-$DATE
ln -snf runtime-$DATE runtime

# Move config & persistent data out of runtime
[ ! -d configurations ] && mv runtime/configurations .
ln -snf /home/openhab/configurations/ runtime/configurations
[ ! -d etc ] && mv runtime/etc .
ln -snf /home/openhab/etc runtime/etc
cd /home/openhab

#
# Add openhab to autostart on boot
#
cp $ADDONS/initscript.sh /etc/init.d/openhab
chmod 774 /etc/init.d/openhab
update-rc.d openhab defaults

#
# Samba setup for easy access to config
#
apt-get install samba
grep openhab.cfg /etc/samba/smb.conf || echo "include = /etc/samba/openhab.cfg" >> /etc/smb.conf
cp $ADDONS/openhab.cfg-samba /etc/samba/openhab.cfg

#
# Install oh_cmd
#
cp $ADDONS/oh_cmd /usr/local/bin/oh_cmd
chmod 755 /usr/local/bin/oh_cmd
cp $ADDONS/oh_cmd-bash_completion /etc/bash_completion.d/oh_cmd
chmod 755 /etc/bash_completion.d/oh_cmd