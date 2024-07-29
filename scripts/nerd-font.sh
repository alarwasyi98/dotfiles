#!/bin/bash

# Function to check internet connection
check_internet() {
  if ! ping -c 1 google.com &>/dev/null; then
    echo "No internet connection. Please connect to the internet and try again."
    exit 1
  fi
}

# Function to detect the Linux distribution
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo $ID
  else
    echo "unknown"
  fi
}

# Function to ensure extractor is installed
ensure_extractor() {
  if ! command -v unzip &>/dev/null; then
    echo "unzip is not installed. Installing unzip..."
    case $(detect_distro) in
    arch)
      sudo pacman -S unzip --noconfirm
      ;;
    ubuntu)
      sudo apt-get update && sudo apt-get install unzip -y
      ;;
    fedora)
      sudo dnf install unzip -y
      ;;
    *)
      echo "Unsupported distribution. Please install unzip manually."
      exit 1
      ;;
    esac
  fi
}

# Function to download and install font
install_font() {
  local font_name=$1
  local download_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.zip"
  local temp_dir=$(mktemp -d)
  local font_dir="/usr/local/share/fonts/${font_name}"

  echo "Downloading ${font_name}..."
  if ! curl -L "$download_url" -o "${temp_dir}/${font_name}.zip"; then
    echo "Failed to download font. Check the font name and your internet connection."
    rm -rf "$temp_dir"
    exit 1
  fi

  echo "Extracting font..."
  unzip -q "${temp_dir}/${font_name}.zip" -d "$temp_dir"

  echo "Installing font to the system..."
  sudo mkdir -p "$font_dir"
  sudo mv "${temp_dir}"/*.ttf "${temp_dir}"/*.otf "$font_dir" 2>/dev/null

  echo "Cleaning up temporary files..."
  rm -rf "$temp_dir"

  echo "Updating font cache..."
  fc-cache -f

  echo "${font_name} has been successfully installed!"
}

# Main script
echo "Nerd Font Installation Script"

# Check internet connection
check_internet

# Ensure extractor is installed
ensure_extractor

# Ask user for font name
read -p "Enter specify Nerd Font name (e.g., FiraCodeMono, JetBrainsMono, UbuntuMono): " font_name

# Install font
install_font "$font_name"
