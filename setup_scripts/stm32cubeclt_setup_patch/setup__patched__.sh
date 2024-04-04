#!/bin/bash

thisdir=$(readlink -m $(dirname $0))
param_installdir=$(readlink -m "$1")

trap 'echo >&2 "Installation failed" ; $thisdir/cleanup.sh ; exit 1' ERR

chmod +x $thisdir/*.sh

# Ask user to agree on license
# $thisdir/prompt_linux_license.sh
# if [ $? -ne 0 ]
# then
# 	$thisdir/cleanup.sh
# 	exit 1
# fi
export LICENSE_ALREADY_ACCEPTED=1

install_clt_as_root=
if [ "$(id -un)" = "root" ]; then
	install_clt_as_root=1
# else
# 	typeset -u answer
# 	read -p "Do you want to install STLinkServer and Udev rules for STLink? Without these packages, you will not be able to use debugging feature.
#              Install them? (you need sudo permission to do that) [Y/n]" answer
# 	if [ ${answer:-Y} = "Y" ]; then
# 		install_debug=1
# 	fi
fi

# Check what kind of sudo is available.
available_sudo=
if [ "$install_debug" ]; then
	if ( type -p gksudo > /dev/null ) && [[ -n "$DISPLAY" ]]; then
		available_sudo='gksudo -D "CubeCLT installation requires root access"'
	else
		available_sudo=sudo
	fi
fi

# Propose the user a free installdir
default_install_prefix=$(cat $thisdir/default_install_path.txt)
if [ -z "$install_clt_as_root" ]; then
	# Use home dir instead of ST official subdir.
	default_install_prefix=$HOME/st/$(basename $default_install_prefix)
fi

typeset -i i
i=1
while true
do
	# Add suffix to subsequent installation if any
	suffix=
	if [ $i -gt 1 ]; then
		suffix=_$i
	fi
	default_install_dir=${default_install_prefix}$suffix
	test -d $default_install_dir || break # Free dir found
	i=$i+1
done

exit_if_not_interactive() {
	# If user has provided this parameter, no interaction
	if [ "$param_installdir" ] ; then
		$thisdir/cleanup.sh
		exit 1
	fi
}

# User confirmation
installdir=$default_install_dir
while true
do
	# if [ -z "$param_installdir" ]; then
	# 	# Interactive
	# 	read -p "STM32CubeCLT install dir? [$installdir] " answer_install_clt_dir

	# 	installdir=${answer_install_clt_dir:-$installdir}
	# else
		# Not interactive
		installdir="$param_installdir"
	# fi

	# Sanity checks
	if [ "$installdir" = "$thisdir" ]; then
		echo "Installation dir cannot be temporary one: $thisdir"
		exit_if_not_interactive
		continue
	fi
	if [ -d "$installdir" ]; then
		echo "$installdir already exists."
		exit_if_not_interactive
		continue
	fi

	if ( umask 022 ; mkdir -p "$installdir" ) ; then
		break
	else
		echo "Cannot create $installdir as user $(id -nu)"
		exit_if_not_interactive
		continue
	fi
done

echo "Installing STM32CubeCLT into $installdir ..."
tar zxf st-stm32cubeclt*.tar.gz -C $installdir

# Install uninstaller
cp \
	uninstall_clt.sh \
	\
	$installdir

if [ "$install_clt_as_root" -o "$install_debug" ]; then
	eval $available_sudo ./install_clt_as_root.sh $installdir $(id -un)
fi

#In case of default path installation, setting PATH variable

version=$(cat $thisdir/version.txt)
export profilefile=cubeclt-bin-path_$version.sh
export profiledir=/etc/profile.d

cubeprog_bindir=$installdir/STM32CubeProgrammer/bin
stlinkgdb_bindir=$installdir/STLink-gdb-server/bin
gnu_bindir=$installdir/GNU-tools-for-STM32/bin
cmake_bindir=$installdir/CMake/bin
ninja_bindir=$installdir/Ninja/bin
metadata_dir=$installdir

#create a profile script setting variable PATH
echo "export PATH=\"$metadata_dir:$cubeprog_bindir:$stlinkgdb_bindir:$cmake_bindir:$ninja_bindir:$gnu_bindir:\$PATH\"" >> $profilefile


#move profile script to etc/profile.d
eval $available_sudo mv $thisdir/$profilefile $profiledir

#Change right access
eval $available_sudo chmod 644 $profiledir/$profilefile


echo "STM32CubeCLT installed successfully"

eval $available_sudo $thisdir/cleanup.sh
