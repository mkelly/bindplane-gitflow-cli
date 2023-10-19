#!/bin/bash

# Define the template, source, and output directories
SOURCE_DIR="source"
OUTPUT_DIR="bindplane_otel"

rm -rf "${OUTPUT_DIR}"

# Create a directory for each command's output
mkdir -p "${OUTPUT_DIR}"

# Fetch the list for the current command from bindplane
bindplane_output=$(bindplane get configs)

# Parse the NAME field from the output and loop through each one
echo "$bindplane_output" | awk 'NR>1 {print $1}' | while read -r name; do
# Fetch the YAML detail for each NAME
yaml_output=$(bindplane get config "$name" -o raw)

# Save the YAML detail to a file in the OUTPUT folder
echo "$yaml_output" > "${OUTPUT_DIR}/${name}.yaml"
done

echo "Completed exporting all configuration files. Results saved to: $OUTPUT_DIR"