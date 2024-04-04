# STM32CubeCLT License Display Patch

The STM32CubeCLT installation utility wants to display its license during setup, and will die trying. This patch fixes it!

Everything in this folder was adapted from Github User [@Rotule666](https://github.com/Rotule666/stm32cubeclt-docker)'s repo, based on his answer to an [ST forum thread](https://community.st.com/t5/stm32cubeide-mcus/can-stm32cubeclt-be-installed-with-programmatically/td-p/57387) covering this topic.

# How does this work?

By default, STM32CubeCLT downloads with a `setup.sh` file that is a compressed bunch of setup scripts mashed together with a binary blob that contains some of the actual utilities. The `st-docker` container unzips it into the `temp` folder in the `/usr/setup` directory. The files in this folder (`stm32cubeclt_setup_patch`) modify the bash file called `setup.sh` to remove all interactive portions that usually cause it to break during setup.

The patch file was last edited for STM32CubeCLT version 1.15 on 2024-04-03. A new patch file may need to be generated if you are attempting to install a future version of STM32CubeCLT.

## Applying the Patch File (used for building the docker image from a Dockerfile)

NOTE: This will apply `setup.patch` that is located in this directory. This will work as long as `setup.sh` has not been modified (e.g. for a new release of STM32CubeCLT).

1. Ensure that `st-stm32cubeclt_<version>_<blablabla>_amd64.sh` has been downloaded into `/usr/setup/temp` and untarred (this should happen automatically with `/usr/setup/install_stm32cubeclt.bash`).
2. Run `bash apply_patch.bash`. This will apply the patch stored in this directory as `setup.patch` to `temp/setup.sh`.
3. If this fails, it's probably because the patch file needs to be updated. See the next section. If it worked, congrats! Enjoy your life.

## Generating a Patch File

If the `setup.patch` file need to be updated, follow the steps below.

1. Ensure that `st-stm32cubeclt_<version>_<blablabla>_amd64.sh` has been downloaded into `/usr/setup/temp` and untarred (this should happen automatically with `/usr/setup/install_stm32cubeclt.bash`).
2. Copy `setup.sh` and save it as `setup_fixed.sh`. Comment out all interactive sections that would bork an automatic install (you can use the old `setup.sh` for inspiration).
3. Run `bash create_patch.bash`. This will create a unified diff between `setup_fixed.sh` and `setup.sh`, retarget it so that it can be properly applied to `setup.sh`, and save it in `/usr/setup/stm32cubeclt_setup_patch/setup.patch`.
4. Run `bash apply_patch.bash` to make sure that your new `setup.patch` worked properly.
5. Create a PR so we can have a new, updated `setup.patch` that works properly!