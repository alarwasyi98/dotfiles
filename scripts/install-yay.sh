#!/bin/bash

# Fungsi untuk memeriksa apakah sistem adalah Arch Linux
check_arch() {
  if [ ! -f /etc/arch-release ]; then
    echo "This script is only for Arch Linux."
    exit 1
  fi
}

# Fungsi untuk memeriksa dan menginstal dependencies
install_dependencies() {
  local deps="git base-devel"
  echo "Checking and installing dependencies..."
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm $deps
}

# Fungsi untuk menginstal yay
install_yay() {
  if command -v yay &>/dev/null; then
    echo "yay is already installed."
    return
  fi

  echo "Installing yay..."
  local temp_dir=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$temp_dir/yay"
  cd "$temp_dir/yay"
  makepkg -si --noconfirm
  cd -
  rm -rf "$temp_dir"
  echo "yay has been successfully installed!"
}

# Main script
echo "AUR Helper (yay) Installation Script for Arch Linux"

# Periksa apakah sistem adalah Arch Linux
check_arch

# Instal dependencies
install_dependencies

# Instal yay
install_yay

echo "Installation complete. You can now use yay to manage AUR packages."
