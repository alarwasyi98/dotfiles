#!/bin/bash

# Function to detect the Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo $ID
    else
        echo "unknown"
    fi
}

# Function to install packages based on the distribution
install_packages() {
    local distro=$(detect_distro)
    local packages="bash bat btop fish git kitty neofetch neovim tmux zsh"
    
    echo "Installing dependencies for dotfiles..."
    
    case $distro in
        arch)
            echo "Detected Arch Linux"
            sudo pacman -Syu --noconfirm
            sudo pacman -S --needed --noconfirm $packages stow
            # Install starship using official script
            if ! command -v starship &>/dev/null; then
                curl -sS https://starship.rs/install.sh | sh
            fi
            ;;
            
        ubuntu|debian)
            echo "Detected Ubuntu/Debian"
            sudo apt update
            sudo apt install -y stow
            # Install packages
            sudo apt install -y bash fish git kitty neofetch tmux zsh
            # Install bat (called batcat in Ubuntu)
            sudo apt install -y batcat
            sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
            # Install btop
            sudo apt install -y btop
            # Install neovim
            sudo apt install -y neovim
            # Install starship
            if ! command -v starship &>/dev/null; then
                curl -sS https://starship.rs/install.sh | sh
            fi
            ;;
            
        fedora)
            echo "Detected Fedora"
            sudo dnf update -y
            sudo dnf install -y $packages stow
            # Install starship
            if ! command -v starship &>/dev/null; then
                curl -sS https://starship.rs/install.sh | sh
            fi
            ;;
            
        *)
            echo "Unsupported distribution: $distro"
            exit 1
            ;;
    esac
}

# Function to create backup of existing configs
backup_configs() {
    echo "Creating backup of existing configurations..."
    backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir" || { echo "Failed to create backup directory."; exit 1; }
    
    # List of config directories to backup
    configs=(".config/bash" ".config/bat" ".config/btop" ".config/fish" 
             ".config/git" ".config/kitty" ".config/neofetch" ".config/nvim" 
             ".config/starship.toml" ".config/tmux" ".config/zsh")
    
    for config in "${configs[@]}"; do
        if [ -e "$HOME/$config" ]; then
            cp -r "$HOME/$config" "$backup_dir/" && echo "Backed up $config" || echo "Failed to backup $config"
        fi
    done
}

# Function to stow dotfiles
stow_dotfiles() {
    echo "Stowing dotfiles..."
    
    # Make sure we're in the right directory
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    cd "$SCRIPT_DIR" || { echo "Failed to change to script directory."; exit 1; }
    
    # Unstow first in case there are existing stowed configs
    stow -D . || echo "Warning: Issues unstowing old configurations."
    
    # Stow the new configurations
    stow .
    
    if [ $? -eq 0 ]; then
        echo "Dotfiles have been successfully stowed!"
    else
        echo "Error occurred while stowing dotfiles"
        exit 1
    fi
}

# Main installation process
main() {
    echo "Starting dotfiles installation..."
    
    # Check if script is run with sudo
    if [ "$EUID" -eq 0 ]; then
        echo "Please do not run this script as root"
        exit 1
    fi
    
    # Install required packages
    install_packages
    
    # Backup existing configurations
    backup_configs
    
    # Stow dotfiles
    stow_dotfiles
    
    echo "Installation complete!"
    echo "Please log out and log back in for all changes to take effect."
    echo "Backup of your old configurations can be found in: $backup_dir"
}

# Run the main function
main
