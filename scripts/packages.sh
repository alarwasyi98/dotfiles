#!/bin/bash

# Fungsi untuk memeriksa dan menginstal paket
install_packages() {
    local packages=(
        base-devel
        stow
        git
        tar
        unzip
        trash-cli
        eza
        bat
        btop
        neofetch
        starship
        bash-completion
        lazygit
        neovim
    )

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "Detected Linux distribution: $NAME"

        case "$ID" in
            ubuntu|debian)
                # Update repository index
                sudo apt-get update

                # Install packages
                sudo apt-get install -y "${packages[@]}" software-properties-common

                # Install eza, starship, lazygit, and btop
                sudo apt-get install -y eza starship

                # Add repositories for lazygit and btop
                sudo add-apt-repository -y ppa:lazygit-team/release
                sudo add-apt-repository -y ppa:aristocratos/btop

                # Update and install lazygit and btop
                sudo apt-get update
                sudo apt-get install -y lazygit btop
                ;;
            arch|manjaro)
                # Install packages using pacman
                sudo pacman -Syu --needed --noconfirm "${packages[@]}" 

                # Install eza, starship, and lazygit from AUR using an AUR helper (like yay or paru)
                if command -v yay &>/dev/null; then
                    yay -S --noconfirm eza starship lazygit
                elif command -v paru &>/dev/null; then
                    paru -S --noconfirm eza starship lazygit
                else
                    echo "Please install an AUR helper like yay or paru to install eza, starship, and lazygit."
                fi
                ;;
            fedora)
                # Install packages using dnf
                sudo dnf install -y "${packages[@]}" 

                # Install additional packages from Fedora's COPR repository
                sudo dnf copr enable -y atim/lazygit
                sudo dnf copr enable -y varlad/ezat
                sudo dnf copr enable -y varlad/starship

                # Install eza, starship, lazygit, and btop
                sudo dnf install -y eza starship lazygit btop
                ;;
            opensuse|sles)
                # Install packages using zypper
                sudo zypper install -y "${packages[@]}" 
                ;;
            *)
                echo "Unsupported Linux distribution: $ID"
                return 1
                ;;
        esac
    else
        echo "Cannot determine Linux distribution"
        return 1
    fi
}

# Menjalankan fungsi untuk menginstal paket
install_packages
