#!/bin/bash

# Output file
output_file="all_files_concatenated.txt"
exclude_files=("package-lock.json")

# Function to process files
process_files() {
    local indent="$1"

    git ls-files | while read -r file; do
        # Skip excluded files
        for exclude in "${exclude_files[@]}"; do
            if [[ "$file" == "$exclude" ]]; then
                continue 2
            fi
        done

        # Check if file exists (in case of issues like deleted files still in index)
        if [ -f "$file" ]; then
            # Add file content to output
            echo -e "\n$indent### File: $file ###\n" >> "$output_file"
            cat "$file" >> "$output_file"
        fi
    done
}

# Count files using git ls-files
count_files() {
    git ls-files | while read -r file; do
        # Skip excluded files
        for exclude in "${exclude_files[@]}"; do
            if [[ "$file" == "$exclude" ]]; then
                continue 2
            fi
        done
        echo "$file"
    done | wc -l
}

# Ensure the script is run inside a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: This script must be run inside a git repository."
    exit 1
fi

# Main script logic
echo "Scanning directory for tracked files (excluding .gitignore and $exclude_files)..."
file_count=$(count_files)
echo "Found $file_count files."

# Prompt the user before proceeding
read -p "Do you wish to proceed? (y/n): " proceed
if [[ "$proceed" != "y" ]]; then
    echo "Operation canceled."
    exit 1
fi

# Clear output file
> "$output_file"

# Process files and generate output
process_files ""

echo "Concatenation complete! Output saved to $output_file"
