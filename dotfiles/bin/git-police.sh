#!/bin/bash

# Script: git-police
# Description: Checks if a Git repository has any uncommitted changes (including untracked files)
# Usage: git-police [repository-directory]
# Exit code: 0 if clean, 1 if changes exist, 2 if error

set -euo pipefail

# Function to display usage
usage() {
    echo "Usage: ${0##*/} [repository-directory]"
    echo "Checks if a Git repository has uncommitted changes."
    echo "Exit codes: 0 = clean, 1 = changes exist, 2 = error"
    exit 2
}

# Function to check if directory is a git repo
is_git_repo() {
    local dir="$1"
    git -C "$dir" rev-parse --git-dir >/dev/null 2>&1
}

# Function to check repository status
check_repo_status() {
    local target_dir="$1"

    # Check if it's a git repository
    if ! is_git_repo "$target_dir"; then
        echo "Error: '$target_dir' is not a Git repository" >&2
        return 2
    fi

    # Check for changes using porcelain format (machine-readable)
    if [ -z "$(git -C "$target_dir" status --porcelain)" ]; then
        echo "Repository is clean: $target_dir"
        return 0
    else
        echo "Repository has changes: $target_dir"
        # Show brief status for context
        git -C "$target_dir" status -s
        return 1
    fi
}

# Main execution
main() {
    local target_dir="${1:-.}"

    # Validate directory exists
    if [ ! -d "$target_dir" ]; then
        echo "Error: Directory '$target_dir' does not exist" >&2
        exit 2
    fi

    # Resolve to absolute path for cleaner output
    target_dir=$(realpath "$target_dir")

    # Check repository status
    check_repo_status "$target_dir"
    exit $?
}

# Handle help flag
if [[ "$#" -gt 1 ]] || [[ "$#" -eq 1 && ("$1" == "-h" || "$1" == "--help") ]]; then
    usage
fi

# Run main function with all arguments
main "$@"