#!/bin/bash
working_dir=$(dirname "$0")/../temp

readarray -d '' patch_file_list < <(find $(dirname "$0") -name "*.patch" -print0)
for patch_file in ${patch_file_list[@]}; do
    patch_filename=$(basename -- "$patch_file")
    filename_to_patch=$(echo $patch_filename | sed "s/.patch//g")
    file_to_patch=$working_dir/$filename_to_patch
    echo "Applying patch file $patch_filename to $file_to_patch"
    patch $file_to_patch $patch_file
done