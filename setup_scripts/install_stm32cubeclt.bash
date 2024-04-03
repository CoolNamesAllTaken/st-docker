#!/bin/bash

stm32clt_linux_sh_share_link_id="1voB0VygyP1h-CEfry6GT5f0uzySs9NyX"
stm32clt_linux_sh_url="https://drive.google.com/uc?export=download&confirm=t&id=$stm32clt_linux_sh_share_link_id"
stm32clt_linux_sh_file=stm32clt_linux.sh

# Install the gdown python utility for downloading the stm32clt install file from google drive.
sudo apt install python3 pip -y
pip install gdown

mkdir temp
python3 download_drive_file.py $stm32clt_linux_sh_url temp/$stm32clt_linux_sh_file

# wget --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$stm32clt_linux_sh_share_link_id" -O- \
#     | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p' > /tmp/confirm \
#     && wget --load-cookies /tmp/cookies.txt --no-check-certificate "https://docs.google.com/uc?export=download&confirm="$(cat /tmp/confirm)"&id=$stm32clt_linux_sh_share_link_id" -O $stm32clt_linux_sh_file \
#     && rm /tmp/cookies.txt /tmp/confirm
# wget -O temp/$stm32clt_linux_sh_file $stm32clt_linux_sh_url

bash temp/$stm32clt_linux_sh_file