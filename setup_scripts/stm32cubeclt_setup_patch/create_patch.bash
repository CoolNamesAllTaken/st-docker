#!/bin/bash
working_dir=$(dirname "$0")/../temp
modified_setup_file=setup_fixed.sh
original_setup_file=setup.sh

# Create a unified diff of the modified setup file (setup_fixed.sh) and the original.
diff -u $working_dir/$original_setup_file $working_dir/$modified_setup_file > $(dirname "$0")/setup.patch

# Change the first line of the patch to target the setup.sh file, not the name of the changed file.
# Changes the matching text on line 1 from "setup_fixed.sh" to "setup.sh".
sed -i "1s/$modified_setup_file/$original_setup_file/" $(dirname "$0")/setup.patch