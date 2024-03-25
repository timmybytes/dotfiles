#!/usr/bin/env bash
#title          :install-vscode-extensions.sh
#description    :Install VS Code extensions from file
#author         :Timothy Merritt
#date           :2024-03-25
#version        :0.0.1
#usage          :./install-vscode-extensions.sh
#notes          :
#bash_version   :5.2.26(1)-release
#============================================================================

cat ~/.dotfiles/vscode/extensions.txt | while read -r extension || [[ -n $extension ]]; do
  code --install-extension "$extension"
done
