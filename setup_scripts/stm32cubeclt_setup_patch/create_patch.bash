#!/bin/bash
working_dir=$(dirname "$0")/../temp
modified_filename_pattern="__patched__"

# Find any modified files by looking for "_fixed" in the filename.
readarray -d '' modified_file_list < <(find $working_dir -name "*$modified_filename_pattern*" -print0)
original_file_list=()
for modified_file in ${modified_file_list[@]}; do
    # Remove "__patched__" from the current element
    original_file_list+=("$(echo $modified_file | sed "s/$modified_filename_pattern//g")")
done
# Print the list of files that were modified
echo "Detected modified versions of the following files:"
for file in ${original_file_list[@]}; do
    echo -e "\t$file"
done

# Generate a patch file
echo "Generating patches..."
for ((i=0; i<${#original_file_list[@]}; i++)); do
    original_file=${original_file_list[$i]}
    modified_file=${modified_file_list[$i]}
    original_filename=$(basename -- "$original_file")
    modified_filename=$(basename -- "$modified_file")
    patch_file=$(dirname "$0")/$original_filename.patch
    echo -e "\tGenerating patch for $original_filename as $patch_file"
    # Create a unified diff of the modified setup file (setup__patched__.sh) and the original.
    diff -u $original_file $modified_file > $patch_file

    # Changes the matching text on line 1 from "setup__patched__.sh" to "setup.sh".
    sed -i "1s/$modified_filename/$original_filename/" $patch_file
done