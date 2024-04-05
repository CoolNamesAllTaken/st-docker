# !/bin/bash

# Create STM32_CUBE_CLT environment variable (without trailing slash).
stm32_cube_clt_dir=$(echo $(ls -td /opt/st/*/ | head -1) | sed 's:/$::')
echo "export STM32_CUBE_CLT_DIR=$stm32_cube_clt_dir" >> /root/.bashrc

# TODO: Maybe change this from hardcoded path to instead use the /etc/profile thing that the ST CLT installer leaves.
echo "export PATH=$stm32_cube_clt_dir:$stm32_cube_clt_dir/STM32CubeProgrammer/bin:$stm32_cube_clt_dir/STLink-gdb-server/bin:\
$stm32_cube_clt_dir/CMake/bin:$stm32_cube_clt_dir/Ninja/bin:$stm32_cube_clt_dir/GNU-tools-for-STM32/bin:$PATH:" >> /root/.bashrc