#!/usr/bin/env bash
#title          :install.sh
#description    :Main install script for .dotfiles
#author         :Timothy Merritt
#date           :2024-03-27
#version        :0.0.1
#usage          :./install.sh
#notes          :
#bash_version   :5.2.26(1)-release
#============================================================================

# Main install script for .dotfiles

# This script will install all the dotfiles and dependencies for:
# - macOS
# - iTerm2
# - zsh
# - git
# - brew
# - VSCode
# - neoVim
# - node/npm/yarn
# - Firefox

# Set macOS defaults
source ./macos/defaults.sh

# Install Homebrew
source ./brew/install.sh

# Install iTerm2
source ./iterm2/install.sh
