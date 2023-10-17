#!/bin/bash

# Directory to start the search; default is the current directory
start_directory="./bindplane"

# Use find command to locate all yaml files and execute bindplane apply on each
find "$start_directory" -name "*.yaml" -type f -exec echo "Applying {}" \; -exec bindplane apply -f {} \;
