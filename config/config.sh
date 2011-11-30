#!/bin/bash

test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$name]..."

#======================================
# SuSEconfig
#--------------------------------------
echo "** Running suseConfig..."
suseConfig

echo "** Running ldconfig..."
/sbin/ldconfig

echo "** setting up services **"


#stip unnecessary libs
baseStripUnusedLibs


#======================================
#--------------------------------------
baseRepo="http://download.opensuse.org/distribution/12.1/repo/oss"
baseName="suse-12.1-oss"
zypper ar $baseRepo $baseName

#======================================
# Remove unneeded packages
#--------------------------------------
rpm -qa | grep yast | xargs rpm -e --nodeps

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

exit 0
