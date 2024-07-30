#!/bin/bash

# Skrip ini memiliki fungsi untuk menginstal
# beberapa aplikasi yang dikonfigurasi menggunakan dotfiles
# Fungsi untuk mendeteksi distribusi
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo $ID
  else
    echo "unknown"
  fi
}

# Fungsi untuk menginstal paket
install_packages() {
  local distro=$(detect_distro)
  local packages="curl wget git neofetch neovim"

  case $distro in
  arch)
    echo "Detected Arch Linux"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm $packages bat btop starship
    ;;
  ubuntu)
    echo "Detected Ubuntu"
    sudo apt update
    sudo apt install -y $packages
    # Install bat (batcat in Ubuntu)
    sudo apt install -y batcat
    # Install btop
    sudo apt install -y btop
    # Install starship
    curl -sS https://starship.rs/install.sh | sh
    ;;
  fedora)
    echo "Detected Fedora"
    sudo dnf update -y
    sudo dnf install -y $packages bat btop
    # Install starship
    curl -sS https://starship.rs/install.sh | sh
    ;;
  *)
    echo "Unsupported distribution: $distro"
    exit 1
    ;;
  esac
}

# Main script
echo "Installing dependencies for dotfiles"

# Periksa apakah script dijalankan sebagai root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root or with sudo."
  exit 1
fi

# Instal paket
install_packages

echo "All dependencies have been installed successfully!"
