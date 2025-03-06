#!/bin/bash

# Output file with .md extension
output_dir="/$HOME/Downloads"
test -d "$output_dir" || mkdir -p "$output_dir"
output_file="${output_dir}/all_files_concatenated.md"
file_list="/tmp/pd_files_to_be_processed"
exclude_files=("package-lock.json" "yarn.lock")

# Function to generate the list of files
generate_file_list() {
    git ls-files | while read -r file; do
        # Skip excluded files
        for exclude in "${exclude_files[@]}"; do
            if [[ "$file" == "$exclude" ]]; then
                continue 2
            fi
        done
        echo "$file"
    done > "$file_list"
}

# Function to process files
process_files() {
    local indent="    "

    echo "   # The content of the following files is listed below:" > $output_file
    while read -r file; do
        # Add file content to output with indentation
        echo -e "${indent}- $file" >> "$output_file"
    done < "$file_list"
    echo "" >> $output_file
    while read -r file; do
        # Add file content to output with indentation
        echo -e "\n$indent### File: $file ###\n" >> "$output_file"
        sed "s/^/$indent/" "$file" >> "$output_file"
        echo -e "\n$indent---\n" >> "$output_file"
    done < "$file_list"
}

# Function to preview files
preview_files() {
    echo "Previewing files to be processed:"
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            size=$(du -h "$file" | cut -f1)
            printf "%-10s %s\n" "$size" "$file"
        else
            echo "File not found: $file"
        fi
    done < "$file_list"
    echo
}

# Function to edit the file list
edit_file_list() {
    echo "Opening file list for editing..."
    nvim "$file_list"
    echo "File list edited. Resuming process..."
}

copy_to_clipboard() {
  if command -v pbcopy &>/dev/null; then
    # macOS
    pbcopy < "$1"
  elif command -v xclip &>/dev/null; then
    # Linux with xclip
    xclip -selection clipboard < "$1"
  elif command -v xsel &>/dev/null; then
    # Linux with xsel
    xsel --clipboard < "$1"
  else
    echo "No clipboard utility found. Please install pbcopy (macOS) or xclip/xsel (Linux)."
    return 1
  fi
}

# Ensure the script is run inside a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: This script must be run inside a git repository."
    exit 1
fi

# Main script logic
echo "Generating list of files to be processed..."
generate_file_list
file_count=$(wc -l < "$file_list")
echo "Found $file_count files to process. File list saved to $file_list."

while true; do
    echo -n "Do you wish to proceed? (y/n/p to preview/e to edit): "
    read -r choice

    case "$choice" in
        y)
            echo "Proceeding with file concatenation..."
            # Clear output file
            > "$output_file"
            process_files
            echo "Concatenation complete! Output saved to $output_file."
            ls -al "$output_file"
            copy_to_clipboard $output_file
            echo "Output copied to clipboard."
            break
            ;;
        n)
            echo "Operation canceled."
            exit 1
            ;;
        p)
            preview_files
            ;;
        e)
            edit_file_list
            ;;
        *)
            echo "Invalid option. Please enter 'y', 'n', 'p', or 'e'."
            ;;
    esac
done


