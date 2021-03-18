#!/usr/bin/env zsh
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
  _omz::update
}

check_npm() {
  npm update
}

main() {
  clear
  printf "%s\n" "Checking for updates..."
  printf "─%.0s" {1..36}
  echo
  printf "%s\n" "--Checking macOS"
  printf "─%.0s" {1..36}
  echo
  check_system
  printf "─%.0s" {1..36}
  echo
  printf "%s\n" "--Checking Oh My Zsh"
  printf "─%.0s" {1..36}
  echo
  # check_ohmyzsh
  omz update
  printf "─%.0s" {1..36}
  echo
  printf "%s\n" "--Checking brew"
  printf "─%.0s" {1..36}
  echo
  check_brew
  printf "─%.0s" {1..36}
  echo
  printf "%s\n" "--Checking npm"
  printf "─%.0s" {1..36}
  echo
  check_npm
  printf "─%.0s" {1..36}
  echo
  printf "%s\n" "Done."
}

echo "testing"
omz
