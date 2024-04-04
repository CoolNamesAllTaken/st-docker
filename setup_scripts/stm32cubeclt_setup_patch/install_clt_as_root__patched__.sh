#!/bin/bash

thisdir=$(readlink -m $(dirname $0))
installdir=$1
install_user=$2


# Setup installer/uninstaller couples.
set \
	st-stlink-udev-rules-*-linux-noarch.sh st-stlink-udev-rules.uninstall.sh \
	st-stlink-server.*.install.sh stlink-server.uninstall.sh \


while [ $# -ne 0 ]; do
	installer=$1
	uninstaller=$2
	shift 2
	(
	if [[ $installer == st-stlink-server.*.install.sh ]]; then
		echo "Overriding stlink-server install preferences with -f"
		sh $installer -f
	fi
	sh $installer
	case $? in
	0)
		# user root might not be able to write into install user dir (ie. NFS mount)
		su $install_user -c "cp $uninstaller $installdir"
		;;
	1)
		# License not accepted. Nothing to do actually.
		;;
	*)
		echo "Something went wrong installing $installer. You may not be able to use debugging feature."
		;;
	esac
	)
done
