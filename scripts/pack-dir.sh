#!/bin/bash

# Output file
output_file="all_files_concatenated.txt"
exclude_files=("package-lock.json")
exclude_dirs=("node_modules")

# Function to recursively process files
process_files() {
    local dir="$1"
    local indent="$2"

    for entry in "$dir"/*; do
        # Skip excluded directories
        for exclude in "${exclude_dirs[@]}"; do
            [[ "$entry" == */$exclude* ]] && continue 2
        done

        if [ -f "$entry" ]; then
            # Skip excluded files
            for exclude in "${exclude_files[@]}"; do
                [[ "$(basename "$entry")" == "$exclude" ]] && continue 2
            done

            # Add file content to output
            echo -e "\n$indent### File: $entry ###\n" >> "$output_file"
            cat "$entry" >> "$output_file"
        elif [ -d "$entry" ]; then
            echo -e "\n$indent### Directory: $entry ###\n" >> "$output_file"
            process_files "$entry" "$indent  "
        fi
    done
}

# Count all files, excluding specified files/directories
count_files() {
    find . -type f ! -path "./node_modules/*" ! -name "package-lock.json" | wc -l
}

# Main script logic
echo "Scanning directory for files..."
file_count=$(count_files)
echo "Found $file_count files (excluding specified files/directories)."

# Prompt the user before proceeding
read -p "Do you wish to proceed? (y/n): " proceed
if [[ "$proceed" != "y" ]]; then
    echo "Operation canceled."
    exit 1
fi

# Clear output file
> "$output_file"

# Start processing from the current directory
process_files "." ""

echo "Concatenation complete! Output saved to $output_file"
