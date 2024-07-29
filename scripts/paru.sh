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
  local deps="git base-devel rust"
  echo "Checking and installing dependencies..."
  sudo pacman -Syu --noconfirm
  sudo pacman -S --needed --noconfirm $deps
}

# Fungsi untuk menginstal paru
install_paru() {
  if command -v paru &>/dev/null; then
    echo "paru is already installed."
    return
  fi

  echo "Installing paru..."
  local temp_dir=$(mktemp -d)
  git clone https://aur.archlinux.org/paru.git "$temp_dir/paru"
  cd "$temp_dir/paru"
  makepkg -si --noconfirm
  cd -
  rm -rf "$temp_dir"
  echo "paru has been successfully installed!"
}

# Main script
echo "AUR Helper (paru) Installation Script for Arch Linux"

# Periksa apakah sistem adalah Arch Linux
check_arch

# Instal dependencies
install_dependencies

# Instal paru
install_paru

echo "Installation complete. You can now use paru to manage AUR packages."
