# Dotfiles for Arch Linux WSL

![Distro Badge](https://img.shields.io/badge/Dotfiles-Arch-blue?style=for-the-badge)

Welcome to my Dotfiles repository! This repository contains the configuration
files and scripts that I use to customize my Linux environment. With the power of [GNU Stow](https://www.gnu.org/software/stow/), these dotfiles are designed to be cross-platform and easily manageable.

This dotfiles repository is currently aimed and tested on [Arch Linux](https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL)

## Installation

> [!CAUTION]
> Always review and understand the script's code before running any executable
> scripts to prevent any undesired modifications to your system.

```bash
# Clone this repo
git clone https://github.com/alarwasyi98/dotfiles.git ~/.dotfiles
cd .dotfiles
# Execute install.sh to install dependencies
./install.sh
```

```bash
# arch-based
sudo pacman -S stow
```

## Usage
Use stow to create symlinks for the configurations you want to use.

```sh
stow .
```

## Contributing

Contributions are welcome! If you have any improvements or suggestions,
feel free to submit a pull request or open an issue.
Please ensure that your contributions align with the repository's goals of providing
a cross-platform and efficient development environment.

Thank you for checking out my Arch Linux Dotfiles!
If you have any questions or need assistance, feel free to reach out. Happy coding!
