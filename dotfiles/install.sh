#!/bin/bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.local/bin"
BIN_DIR="$REPO_DIR/bin"

echo "Installing scripts from $BIN_DIR to $TARGET_DIR"
mkdir -p "$TARGET_DIR"

# Check if bin directory exists
if [ ! -d "$BIN_DIR" ]; then
    echo "Error: bin directory not found at $BIN_DIR" >&2
    exit 1
fi

# First, make all scripts executable and then symlink them
find "$BIN_DIR" -type f -name "*" | while read -r script; do
    script_name=$(basename "$script")

    # Skip hidden files (like .DS_Store, etc.)
    if [[ "$script_name" == .* ]]; then
        continue
    fi

    # Make the script executable
    if [ ! -x "$script" ]; then
        echo "Making executable: $script_name"
        chmod +x "$script"
    fi

    # Create the symlink
    ln -sf "$script" "$TARGET_DIR/$script_name"
    echo "✓ Linked: $script_name"
done

echo "Installation complete. Your scripts are ready to use!"