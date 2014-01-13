#!/bin/bash
#================
# FILE          : config.sh
#----------------
# PROJECT       : OpenSuSE KIWI Image System
# COPYRIGHT     : (c) 2006 SUSE LINUX Products GmbH. All rights reserved
#               :
# AUTHOR        : Marcus Schaefer <ms@suse.de>
#               :
# BELONGS TO    : Operating System images
#               :
# DESCRIPTION   : configuration script for SUSE based
#               : operating systems
#               :
#               :
# STATUS        : BETA
#----------------
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Mount system filesystems
#--------------------------------------
baseMount

#======================================
# Setup baseproduct link
#--------------------------------------
suseSetupProduct

#======================================
# Add missing gpg keys to rpm
#--------------------------------------
suseImportBuildKey

#======================================
# Activate services
#--------------------------------------
suseInsertService sshd

#======================================
# Setup default target, multi-user
#--------------------------------------
baseSetRunlevel 5

#==========================================
# remove package docs
#------------------------------------------
rm -rf /usr/share/doc/packages/*
rm -rf /usr/share/doc/manual/*
rm -rf /opt/kde*

#======================================
# only basic version of vim is
# installed; no syntax highlighting
#--------------------------------------
sed -i -e's/^syntax on/" syntax on/' /etc/vimrc

#======================================
# SuSEconfig
#--------------------------------------
suseConfig

baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER lightdm
baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER_REMOTE_ACCESS yes
baseUpdateSysConfig /etc/sysconfig/displaymanager DISPLAYMANAGER_STARTS_XSERVER yes
baseUpdateSysConfig /etc/sysconfig/windowmanager DEFAULT_WM i3
baseUpdateSysConfig /etc/sysconfig/language RC_LANG pl_PL.UTF-8


systemctl enable NetworkManager.service

#======================================
# Add 13.2 repo
#--------------------------------------
baseRepo="http://download.opensuse.org/distribution/13.2/repo/oss"
baseName="suse-13.2"
zypper ar $baseRepo $baseName

#======================================
# Remove yast packages
#--------------------------------------
rpm -qa | grep yast | xargs rpm -e --nodeps

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

exit 0
