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

# Install ninja for building C/C++
RUN apt install -y ninja-build

# Install GDB for local debugging
RUN ["/usr/bin/bash", "-c", "apt -y install gdb"]

# Install CMAKE.
RUN apt install -y cmake

# Install arm-none-eabi-gcc.
RUN ["/usr/bin/bash", "-c", "/usr/setup/install_arm_none_eabi.bash"]

# Install the STM32 Command Line Tools package.
RUN ["/usr/bin/bash", "-c", "/usr/setup/install_stm32cubeclt.bash"]

# Export the STM32_CUBE_CLT_DIR environment variable as the path to the newest folder in /opt/st/.
RUN sudo bash modify_path.bash

# Put users back in the root directory when starting up.
WORKDIR /