#!/usr/bin/env bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 \"search-string\""
    exit 1
fi

search_term="$1"
REVIEW_FILE="/tmp/matching-files-for-review.txt"
FINAL_FILE="/tmp/matching-files-final.txt"

# Start fresh
> "$REVIEW_FILE"
> "$FINAL_FILE"

# Step 1: Collect all matching commits/files into REVIEW_FILE
echo "# Matching commits and files for '$search_term':" > "$REVIEW_FILE"
echo "# Delete the versions you don't want to keep. Save and exit." >> "$REVIEW_FILE"
echo "#" >> "$REVIEW_FILE"

while read -r commit; do
    git grep -l "$search_term" "$commit" | while read -r line; do
        filename="${line#*:}"
        echo "$commit $filename" >> "$REVIEW_FILE"
    done
done < <(git rev-list --all)

# Open it in nvim for user review/edit
nvim "$REVIEW_FILE"

# Step 2: Process only the lines that remain after editing
echo "Contents:" >> "$FINAL_FILE"

grep -v '^#' "$REVIEW_FILE" | grep -v '^[[:space:]]*$' | while read -r commit file; do
    echo "$commit $file" >> "$FINAL_FILE"
    git show "$commit:$file" >> "$FINAL_FILE" 2>/dev/null || echo "(file missing in commit)" >> "$FINAL_FILE"
    echo "" >> "$FINAL_FILE"
done

echo "Final content saved to $FINAL_FILE"

