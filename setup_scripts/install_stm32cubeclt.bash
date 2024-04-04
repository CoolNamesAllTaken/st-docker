#!/bin/bash

stm32clt_linux_sh_share_link_id="1voB0VygyP1h-CEfry6GT5f0uzySs9NyX"
stm32clt_linux_sh_url="https://drive.google.com/uc?export=download&confirm=t&id=$stm32clt_linux_sh_share_link_id"
# NOTE: The filename is important, since it's used for versioning within the install script itself!
stm32clt_linux_sh_file=st-stm32cubeclt_1.15.0_20695_20240315_1429_amd64.sh
stm32clt_install_dir=/usr/local/stm32clt
temp_dir=$(dirname "$0")/temp

if [ -d $temp_dir ]; then
    # Remove the temp directory if it already exists.
    rm -rf $temp_dir
fi
mkdir $temp_dir
python3 download_drive_file.py $stm32clt_linux_sh_url $temp_dir/$stm32clt_linux_sh_file

# Un-tar the setup file.
bash $temp_dir/$stm32clt_linux_sh_file --tar -xvf -C $temp_dir
bash stm32cubeclt_setup_patch/apply_patch.bash

exit

if [ -d $stm32clt_install_dir ]; then
    # Remove old install directory if it already exists.
    rm -rf $stm32clt_install_dir
fi
original_dir="$PWD"
cd $temp_dir # CLT installer needs to be run from its own directory.
bash setup.sh $stm32clt_install_dir
cd $original_dir