--- stm32cubeclt_setup_patch/../temp/st-stlink-server.2.1.1-1-linux-amd64.install.sh	2024-04-04 20:20:32.531616917 +0000
+++ stm32cubeclt_setup_patch/../temp/st-stlink-server.2.1.1-1-linux-amd64.install__patched__.sh	2024-04-04 20:20:57.815405948 +0000
@@ -13,7 +13,7 @@
 
 label="STM STLink-Server installer"
 script="./setup.sh"
-scriptargs=""
+scriptargs="-f"
 licensetxt=""
 helpheader=''
 targetdir="makeself_dir_CF037U"
