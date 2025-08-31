#!/bin/bash
# Create the target directory if it doesn't exist
mkdir -p ~/bin

# Symlink all scripts from the repo's bin/ to ~/bin/
for script in $(find "$(cd "$(dirname "$0")" && pwd)/bin" -type f); do
  chmod +x "$script"
  ln -sf "$script" ~/bin/
  echo "Linked: $(basename "$script")"
done

echo "Installation complete. Ensure ~/bin is in your PATH."