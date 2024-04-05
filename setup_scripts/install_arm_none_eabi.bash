#!/bin/bash

latest_arm_none_eabi=gcc-arm-none-eabi-10.3-2021.10
latest_arm_none_eabi_version_date_str=$(echo $latest_arm_none_eabi | grep -oE "[0-9]+.[0-9]+\-[0-9]+.[0-9]+")
latest_arm_none_eabi_url=https://developer.arm.com/-/media/Files/downloads/gnu-rm/$latest_arm_none_eabi_version_date_str/$latest_arm_none_eabi-x86_64-linux.tar.bz2

# Install dependencies
sudo apt -y install libncurses-dev
sudo ln -s /usr/lib/x86_64-linux-gnu/libncurses.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5
sudo ln -s /usr/lib/x86_64-linux-gnu/libtinfo.so.6 /usr/lib/x86_64-linux-gnu/libtinfo.so.o5
sudo apt -y install python3
sudo apt install -y build-essential

# Remove previous installation if it exists.
sudo apt remove gcc-arm-none-eabi

mkdir temp
wget -O temp/${latest_arm_none_eabi}.tar.bz2 $latest_arm_none_eabi_url

# Explicitly create the destination directory.
sudo mkdir /usr/local/$latest_arm_none_eabi

# Make sure bzip2 exists so that tar doesn't crash!
sudo apt install -y bzip2

# Un-tar the files into a versioned arm-none-eabi folder in /usr/local.
# --strip-components 1 option removes the top level directory
sudo tar xjfv temp/${latest_arm_none_eabi}.tar.bz2 -C /usr/local/$latest_arm_none_eabi --strip-components 1

# Creat symlinks in /usr/bin
sudo ln -s /usr/local/${latest_arm_none_eabi}/bin/arm-none-eabi-gcc /usr/bin/arm-none-eabi-gcc
sudo ln -s /usr/local/${latest_arm_none_eabi}/bin/arm-none-eabi-g++ /usr/bin/arm-none-eabi-g++
sudo ln -s /usr/local/${latest_arm_none_eabi}/bin/arm-none-eabi-gdb /usr/bin/arm-none-eabi-gdb
sudo ln -s /usr/local/${latest_arm_none_eabi}/bin/arm-none-eabi-size /usr/bin/arm-none-eabi-size
sudo ln -s /usr/local/${latest_arm_none_eabi}/bin/arm-none-eabi-objcopy /usr/bin/arm-none-eabi-objcopy
sudo ln -s /usr/local/${latest_arm_none_eabi}/bin/arm-none-eabi-objdump /usr/bin/arm-none-eabi-objdump
# Add other required commands here!

rm -rf temp