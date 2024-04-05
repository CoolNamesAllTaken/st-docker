#!/bin/bash

stm32clt_linux_sh_share_link_id="1voB0VygyP1h-CEfry6GT5f0uzySs9NyX"
stm32clt_linux_sh_url="https://drive.google.com/uc?export=download&confirm=t&id=$stm32clt_linux_sh_share_link_id"
# NOTE: The filename is important, since it's maybe used for versioning within the install script itself!
stm32clt_linux_sh_file=st-stm32cubeclt_1.15.0_20695_20240315_1429_amd64.sh
stm32clt_install_dir=
temp_dir=$(dirname "$0")/temp

# Allow user to set an option to skip installation, and just leave un-tarred files in the temp directory.
# This is used for creating a new patch.
untar_only=0
if [ $1 = "--untar-only" ]; then
    untar_only=1
fi

if [ -d $temp_dir ]; then
    # Remove the temp directory if it already exists.
    rm -rf $temp_dir
fi
mkdir $temp_dir
python3 download_drive_file.py $stm32clt_linux_sh_url $temp_dir/$stm32clt_linux_sh_file

# Un-tar the setup file.
bash $temp_dir/$stm32clt_linux_sh_file --tar -xvf -C $temp_dir

# Exit if we don't want to apply the patch and install (necessary for creating a new patch).
if (( $untar_only != 0 )); then
    exit
fi

# Apply the patch to all files that should be modified.
bash stm32cubeclt_setup_patch/apply_patch.bash

if [ -d $stm32clt_install_dir ]; then
    # Remove old install directory if it already exists.
    rm -rf $stm32clt_install_dir
fi
original_dir="$PWD"
cd $temp_dir # CLT installer needs to be run from its own directory.
bash setup.sh $stm32clt_install_dir
cd $original_dir