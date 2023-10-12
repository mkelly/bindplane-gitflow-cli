#!/bin/bash

# Define the template, source, and output directories
TEMPLATE_FILE="raw_otel_template.yaml"
SOURCE_DIR="source"
OUTPUT_DIR="output"

# Check if the template file exists
if [[ ! -f $TEMPLATE_FILE ]]; then
    echo "Error: $TEMPLATE_FILE not found!"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Process each YAML file in the source directory
for CONFIG_FILE in $SOURCE_DIR/*.yaml; do
    # Check if CONFIG_FILE is a regular file before processing
    if [[ -f $CONFIG_FILE ]]; then
        # Extract the filename without directory and extension for the metadata name placeholder
        filename=$(basename -- "$CONFIG_FILE")
        name_without_extension="${filename%.*}"

        # Extract the content of CONFIG_FILE into a variable
        otel_content=$(<$CONFIG_FILE)

        # Export the variable to make it accessible for yq
        export otel_content

        # Define output file name
        OUTPUT_FILE="$OUTPUT_DIR/merged_$name_without_extension.yaml"

        # Inject the content from CONFIG_FILE into TEMPLATE_FILE and save to OUTPUT_FILE
        yq eval '.spec.raw = env(otel_content) | .metadata.name = env(name_without_extension)' $TEMPLATE_FILE > $OUTPUT_FILE
    fi
done

# Inform the user of success
echo "Merge completed for all YAML files in $SOURCE_DIR. Results saved to: $OUTPUT_DIR"
