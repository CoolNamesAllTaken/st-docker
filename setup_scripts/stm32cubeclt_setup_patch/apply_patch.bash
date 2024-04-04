#!/bin/bash
working_dir=$(dirname "$0")/../temp

patch $working_dir/setup.sh $(dirname "$0")/setup.patch