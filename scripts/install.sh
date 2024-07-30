#!/usr/bin/env bash

set -e

# Konfigurasi
DOTFILES_REPO="https://github.com/alarwasyi98/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Fungsi untuk logging
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $1"
}

# Fungsi untuk meminta input user
get_user_input() {
  read -p "$1 [$2]: " input
  echo "${input:-$2}"
}

# Instalasi dependensi
install_dependencies() {
  log "Installing Dependencies..."
  if command -v pacman &>/dev/null; then
    sudo pacman -Syu --noconfirm git stow curl
  else
    log "Can't detect any package manager. install Git, Stow, and Curl manually."
    exit 1
  fi
}

# Clone repositori dotfiles
clone_dotfiles() {
  if [ -d "$DOTFILES_DIR" ]; then
    log "Dotfiles directory exists. Doing update..."
    cd "$DOTFILES_DIR" && git pull
  else
    log "Clonning dotfiles..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi
}

# Konfigurasi Git
setup_git() {
  log "Configurate Git..."
  git_name=$(get_user_input "Input your Git Username" "$(git config --global user.name)")
  git_email=$(get_user_input "Input your Git Email" "$(git config --global user.email)")

  git config --global user.name "$git_name"
  git config --global user.email "$git_email"
}

# Setup SSH
setup_ssh() {
  log "Manage SSH..."
  if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    ssh-keygen -t rsa -b 4096 -C "$git_email" -f "$HOME/.ssh/id_rsa" -N ""
  fi
  eval "$(ssh-agent -s)"
  ssh-add "$HOME/.ssh/id_rsa"
  log "Your Public SSH:"
  cat "$HOME/.ssh/id_rsa.pub"
}

# Instalasi dotfiles menggunakan Stow
install_dotfiles() {
  log "Installing Dotfiles..."
  cd "$DOTFILES_DIR"
  for dir in */; do
    if [[ "${dir%/}" != "scripts" ]]; then
      stow -v -R -t "$HOME" "${dir%/}"
    fi
  done
}

# Konfigurasi Neovim (opsional, sesuaikan dengan kebutuhan)
setup_neovim() {
  if command -v nvim &>/dev/null; then
    log "Configurate Neovim..."
    nvim --headless "+Lazy! sync" +qa
  fi
}

# Fungsi utama
main() {
  log "Initialize dotfiles..."
  install_dependencies
  clone_dotfiles
  setup_git
  setup_ssh
  install_dotfiles
  setup_neovim
  log "Dotfiles Installation Succesfully!!"
}

# Jalankan fungsi utama
main
