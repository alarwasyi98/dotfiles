#!/bin/bash

# Function to remove a directory if it exists
remove_if_exists() {
  if [ -d "$1" ]; then
    rm -rf "$1"
    echo "Removed: $1"
  else
    echo "Directory not found: $1"
  fi
}

echo "Starting Neovim configuration removal..."

# Remove Neovim configurations
remove_if_exists "$HOME/.config/nvim"
remove_if_exists "$HOME/.local/share/nvim"
remove_if_exists "$HOME/.local/state/nvim"
remove_if_exists "$HOME/.cache/nvim"

echo "Neovim configuration removal completed!"
