# Dotfiles for Arch Linux WSL

![Distro Badge](https://img.shields.io/badge/Dotfiles-Arch_BTW-blue?style=for-the-badge)

Welcome to my Arch Linux WSL Dotfiles repository! This repository contains the configuration files and scripts that I use to customize my Arch Linux environment on Windows Subsystem for Linux (WSL). With the power of [GNU Stow](https://www.gnu.org/software/stow/), these dotfiles are designed to be cross-platform and easily manageable.

> *What?! Arch on Windows?*
> Hell yeah!, you can find the Documentation [**Here!**](https://github.com/yuk7/ArchWSL)

This dotfiles repository is currently aimed for [**Arch on WSL**](https://ubuntu.com/wsl), and [**Ubuntu on WSL**](https://ubuntu.com/desktop), tested against versions **20.04** and **22.04**. See how to get started with WSL [here](https://docs.microsoft.com/pt-br/windows/wsl/install-win10).

It's also suitable for use in [**GitHub Codespaces**](https://docs.github.com/codespaces/customizing-your-codespace/personalizing-codespaces-for-your-account#dotfiles), [**Gitpod**](https://www.gitpod.io/docs/config-dotfiles), [**VS Code Remote - Containers**](https://code.visualstudio.com/docs/remote/containers#_personalizing-with-dotfile-repositories), or even Linux distributions that are not Arch or Ubuntu, through the [**minimum mode**](#configuration).

## Table of Contents

- [Dotfiles for Arch Linux WSL](#dotfiles-for-arch-linux-wsl)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Features](#features)
  - [Installation](#installation)
  - [Software Included](#software-included)
  - [Contributing](#contributing)
  - [License](#license)

## Introduction

This repository aims to provide a seamless setup for my development environment, leveraging Arch Linux on WSL. The configurations include setups for terminal emulators, text editors, shell prompts, and various utilities that enhance productivity and development efficiency.

## Features

- **Cross-Platform Compatibility:** Configurations are designed to work on both WSL and native Linux environments.
- **Easy Management with GNU Stow:** Simplify dotfile management with symlinked directories, making it easy to update, add, or remove configurations.
- **Custom Shell Prompt:** Personalized shell prompt with Starship for a clean and informative command line experience.
- **Enhanced Terminal Experience:** Includes customizations for Neovim, Neofetch, and more.
- **Efficient Development Tools:** Pre-configured setups for Git, Bat, and more.
- **Scripted Installations:** Automate the installation process for easy setup on new machines.

## Installation

To get started with these dotfiles, you'll need to have Arch Linux set up on WSL and install GNU Stow. Follow these steps to set up the environment:

1. **Clone the Repository:**

   ```bash
   # Clone this repo
   git clone https://github.com/alarwasyi98/dotfiles.git ~/.dotfiles
   cd .dotfiles

   # Execute install.sh to install dependencies
   ./install.sh

2. **Install GNU Stow:**

    Make sure GNU Stow is installed on your system. You can install it using your package manager:

    ``` bash
    sudo pacman -S stow
    ```

3. **Use Stow to Symlink Dotfiles:**

    Use stow to create symlinks for the configurations you want to use. For example, to set up the Neovim configuration:

    ``` bash
    stow neovim
    ```

    This command will symlink the files from the neovim directory to your home directory.

4. **Repeat for Other Configurations:**

    Use stow for other configurations you want to set up:

    ``` bash
    stow bash
    stow git
    stow starship
    stow neofetch

    # etc
    ```

## Usage

Once the dotfiles are symlinked using GNU Stow, you can start using the customized environment. Open your terminal and enjoy the personalized settings.

- *Neovim*: Launch Neovim with custom plugins and settings by typing nvim.
- *Git*: Use Git with your pre-configured .gitconfig.
- *Starship* Prompt: Enjoy the customized shell prompt with additional information.
- *Neofetch*: Display system information with custom settings using neofetch.

## Configuration

The repository is organized into directories for each application or tool. Each directory contains the configuration files specific to that tool. Feel free to explore and modify the configurations to suit your preferences.

Stow Convention Structure:

``` shell
dotfiles/
├── bash/
│   ├── .bashrc
│   └── .bash_aliases
├── git/
│   └── .gitconfig
├── neovim/
│   ├── .config/
│   │   └── nvim/
│   │       ├── init.vim
│   │       └── plugins.vim
├── starship/
│   └── .config/
│       └── starship.toml
├── neofetch/
│   └── .config/
│       └── neofetch/
│           └── config.conf
└── bat/
    └── .config/
        └── bat/
            └── config
```

## Software Included

Here is a list of software configurations included in this repository:

## Contributing

Contributions are welcome! If you have any improvements or suggestions, feel free to submit a pull request or open an issue. Please ensure that your contributions align with the repository's goals of providing a cross-platform and efficient development environment.

## License

This project is licensed under the MIT License. Feel free to use, modify, and distribute these dotfiles as you see fit.

Thank you for checking out my Arch Linux WSL Dotfiles! If you have any questions or need assistance, feel free to reach out. Happy coding!

