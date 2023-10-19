#!/bin/bash

# Directory to start the search; default is the current directory
start_directory="./bindplane/configuration"

mkdir -p "${start_directory}"

bindplane_output=$(bindplane get configs)

# Parse the NAME field from the output and loop through each one
echo "$bindplane_output" | awk 'NR>1 {print $1}' | while read -r name; do
    bindplane rollout start "$name"
done

echo "Configuration rollout started."

