#!/usr/bin/env bash
#title          :updoc.sh
#description    :Update Doctor - check for user & system updates
#author         :Timothy Merritt
#date           :2021-02-09
#version        :0.1.0
#usage          :./updoc.sh
#notes          :
#bash_version   :5.0.18(1)-release
#============================================================================

# Check for updates automatically, display options for user

check_system() {
  # Ignoring certain updates (Big Sur)
  # ex: sudo softwareupdate --ignore iWeb3.0.2-3.0.2
  softwareupdate -l
}

check_brew() {
  brew update
}

check_ohmyzsh() {
  omz update
}

check_npm() {
  npm
}

main() {
  printf "%s\n" "Checking for updates..."
  check_system
}

main
