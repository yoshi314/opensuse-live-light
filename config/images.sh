#!/bin/sh
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

echo "Configure image: [$kiwi_iname]..."

#==========================================
# remove unneeded packages
#------------------------------------------
rpm -e --nodeps --noscripts \
	$(rpm -q `baseGetPackagesForDeletion` | grep -v "is not installed")

#==========================================
# umount /proc
#------------------------------------------
umount /proc &>/dev/null

echo "127.0.0.2       linux.site linux" >> /etc/hosts
echo "127.0.0.1       suse-openbox localhost" >> /etc/hosts

exit 0