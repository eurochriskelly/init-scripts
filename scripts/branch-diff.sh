#!/bin/bash
#
# Purpose:
#   Compares two git branches by checking out both in a temporary directory,
#   using "git ls-files" to list tracked files, and then displaying the files
#   present in one branch but not the other.
#
# Usage:
#   ./branch_diff.sh <branch1> <branch2>
#
#   If branch names are not provided as arguments, the script will list available
#   local branches and prompt you to select two.
#
# Requirements:
#   - Must be run from the root of a git repository.
#   - Git must be installed.
#

# Verify current directory is a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not a git repository."
    exit 1
fi

select_branch() {
    local prompt="$1"
    local branches
    branches=$(git for-each-ref --format="%(refname:short)" refs/heads/)
    if [ -z "$branches" ]; then
         echo "No local branches found."
         exit 1
    fi
    local index=1
    declare -a branch_arr
    while IFS= read -r branch; do
        branch_arr+=("$branch")
        echo "$index) $branch"
        ((index++))
    done <<< "$branches"

    local choice
    while true; do
        read -p "$prompt " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#branch_arr[@]}" ]; then
            echo "${branch_arr[$((choice-1))]}"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
}

# Get branch names from arguments or prompt the user
if [ $# -ge 2 ]; then
    branch1="$1"
    branch2="$2"
else
    echo "Branch names not provided."
    branch1=$(select_branch "Select branch 1 (number):")
    branch2=$(select_branch "Select branch 2 (number):")
fi

# Create a temporary directory in /tmp and ensure cleanup on exit
tmp_dir=$(mktemp -d /tmp/git_branch_compare.XXXXXX)
if [ ! -d "$tmp_dir" ]; then
    echo "Error: Could not create temporary directory."
    exit 1
fi
trap 'rm -rf "$tmp_dir"' EXIT

# Clone the current repository into two separate directories
git clone . "$tmp_dir/branch1" > /dev/null 2>&1
git clone . "$tmp_dir/branch2" > /dev/null 2>&1

# Checkout the specified branches in each clone
pushd "$tmp_dir/branch1" > /dev/null
if ! git checkout "$branch1" > /dev/null 2>&1; then
    echo "Error: Branch '$branch1' does not exist."
    exit 1
fi
popd > /dev/null

pushd "$tmp_dir/branch2" > /dev/null
if ! git checkout "$branch2" > /dev/null 2>&1; then
    echo "Error: Branch '$branch2' does not exist."
    exit 1
fi
popd > /dev/null

# Generate sorted file lists for each branch
git -C "$tmp_dir/branch1" ls-files | sort > "$tmp_dir/branch1_files.txt"
git -C "$tmp_dir/branch2" ls-files | sort > "$tmp_dir/branch2_files.txt"

# Compare file lists:
#  - Files in branch1 not in branch2
#  - Files in branch2 not in branch1
files_only_in_branch1=$(comm -23 "$tmp_dir/branch1_files.txt" "$tmp_dir/branch2_files.txt")
files_only_in_branch2=$(comm -13 "$tmp_dir/branch1_files.txt" "$tmp_dir/branch2_files.txt")

# Output results in the required format
echo "Branch $branch1 has the following not present in $branch2:"
if [ -z "$files_only_in_branch1" ]; then
    echo "None"
else
    echo "$files_only_in_branch1"
fi

echo ""
echo "Branch $branch2 has the following not present in $branch1:"
if [ -z "$files_only_in_branch2" ]; then
    echo "None"
else
    echo "$files_only_in_branch2"
fi

# Temporary files and directories are cleaned up automatically.
