FROM ubuntu
ADD setup_scripts /usr/setup
WORKDIR /usr/setup

# NOTE: don't run this before updating all git submodules!

# Install sudo to allow the use of scripts meant for use in non-root environment.
RUN apt update && apt -y install sudo
RUN apt -y install wget

# Install the gdown python utility for downloading the stm32clt install file from google drive.
RUN apt install python3 pip -y
RUN ["/usr/bin/bash", "-c", "pip install gdown"]

RUN ["/usr/bin/bash", "-c", "/usr/setup/install_stm32cubeclt.bash"]

# Install GDB for local debugging
# RUN ["/usr/bin/bash", "-c", "apt -y install gdb"]