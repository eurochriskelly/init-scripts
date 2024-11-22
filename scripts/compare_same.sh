#!/bin/bash

# Usage: bash compare_name.sh --folder1 path1/ --folder2 path2/

# Function to display usage
usage() {
    echo "Usage: bash $0 --folder1 path1/ --folder2 path2/"
    exit 1
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --folder1)
            FOLDER1="$2"
            shift 2
            ;;
        --folder2)
            FOLDER2="$2"
            shift 2
            ;;
        *)
            echo "Unknown parameter passed: $1"
            usage
            ;;
    esac
done

# Check if both folders are provided
if [[ -z "$FOLDER1" || -z "$FOLDER2" ]]; then
    echo "Both --folder1 and --folder2 must be provided."
    usage
fi

# Check if folders exist and are directories
if [[ ! -d "$FOLDER1" ]]; then
    echo "Error: Folder1 '$FOLDER1' does not exist or is not a directory."
    exit 1
fi

if [[ ! -d "$FOLDER2" ]]; then
    echo "Error: Folder2 '$FOLDER2' does not exist or is not a directory."
    exit 1
fi

# Create /tmp/diffs directory if it doesn't exist
DIFF_DIR="/tmp/diffs"
mkdir -p "$DIFF_DIR"

# Prepare the report header
printf "%-20s %-10s %-10s\n" "FILENAME" "SAME" "SIZE"

# Iterate over files in folder1
for filepath in "$FOLDER1"/*; do
    filename=$(basename "$filepath")
    file1="$FOLDER1/$filename"
    file2="$FOLDER2/$filename"

    # Check if it's a regular file
    if [[ ! -f "$file1" ]]; then
        continue
    fi

    # Check if the same file exists in folder2
    if [[ ! -f "$file2" ]]; then
        printf "%-20s %-10s %-10s\n" "$filename" "no" "N/A (missing in folder2)"
        continue
    fi

    # Compute MD5 checksums
    md5_1=$(md5sum "$file1" | awk '{print $1}')
    md5_2=$(md5sum "$file2" | awk '{print $1}')

    # Get size of file1
    size=$(stat -c%s "$file1")

    if [[ "$md5_1" == "$md5_2" ]]; then
        same="yes"
    else
        same="no"
        # Perform diff ignoring whitespace and save to /tmp/diffs/
        diff -w "$file1" "$file2" > "$DIFF_DIR/$filename"
    fi

    # Print the result
    printf "%-20s %-10s %-10s\n" "$filename" "$same" "$size"
done
