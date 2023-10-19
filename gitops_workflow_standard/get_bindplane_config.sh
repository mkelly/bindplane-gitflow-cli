#!/bin/bash

# Define the template, source, and output directories
SOURCE_DIR="source"
OUTPUT_DIR="bindplane"

# Array of commands to automatically execute
declare -a commands=("configuration" "destination")

for command in "${commands[@]}"; do
  # Create a directory for each command's output
  mkdir -p "${OUTPUT_DIR}/$command"
  
  # Fetch the list for the current command from bindplane
  bindplane_output=$(bindplane get "${command}s")  # Appending 's' to get the list

  # Parse the NAME field from the output and loop through each one
  echo "$bindplane_output" | awk 'NR>1 {print $1}' | while read -r name; do
    # Fetch the YAML detail for each NAME
    yaml_output=$(bindplane get "$command" "$name" -o yaml)
    
    # Save the YAML detail to a file in the OUTPUT folder
    echo "$yaml_output" > "${OUTPUT_DIR}/$command/${name}.yaml"
  done
done

echo "Completed exporting all configuration files. Results saved to: $OUTPUT_DIR"