#!/bin/bash
#================
# FILE          : config.sh
#----------------
# PROJECT       : OpenSuSE KIWI Image System
# COPYRIGHT     : (c) 2006,2007,2008 SUSE LINUX Products GmbH. All rights reserved
#               :
# AUTHOR        : Marcus Schaefer <ms@suse.de>, Stephan Kulow <coolo@suse.de>
#               :
# LICENSE       : BSD
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

set -e

exec | tee /var/log/config.log
exec 2>&1

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$name]..."

chkconfig boot.ldconfig off

#======================================
# /etc/sudoers hack to fix #297695 
# (Installation Live CD: no need to ask for password of root)
#--------------------------------------
sed -i -e "s/ALL ALL=(ALL) ALL/ALL ALL=(ALL) NOPASSWD: ALL/" /etc/sudoers 
chmod 0440 /etc/sudoers

# delete passwords
passwd -d root
passwd -d tux
# empty password is ok
pam-config -a --nullok

: > /var/log/zypper.log

mv /var/lib/livecd/*.pdf /home/linux || true
rmdir /var/lib/livecd || true

#======================================
# SuSEconfig
#--------------------------------------
suseConfig

rm -rf /var/cache/zypp/packages

# bug 544314
sed -i -e 's,^\(.*pam_gnome_keyring.so.*\),#\1,'  /etc/pam.d/common-auth-pc

baseSetRunlevel 5
baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER_AUTOLOGIN tux
baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER gdm
baseUpdateSysConfig /etc/sysconfig/keyboard KEYTABLE us.map.gz
baseUpdateSysConfig /etc/sysconfig/keyboard YAST_KEYBOARD english-us,pc104
baseUpdateSysConfig /etc/sysconfig/clock HWCLOCK "-u"

baseUpdateSysConfig /etc/sysconfig/network/config NETWORKMANAGER yes

