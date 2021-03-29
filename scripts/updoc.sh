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
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;48     Light Cyan    1;48
# Light Gray   0;37     White         1;37

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color, resets
PENDING="${YELLOW}●${NC}"
FAILED="${RED}𐄂${NC}"
SUCCEEDED="${GREEN}✓${NC}"

logo="
                        ____
    __     __  ______  / __ \____  _____     __
 __/ /_   / / / / __ \/ / / / __ \/ ___/  __/ /_
/_  __/  / /_/ / /_/ / /_/ / /_/ / /__   /_  __/
 /_/     \__,_/ .___/_____/\____/\___/    /_/
             /_/
"

# Create tmpfile to store final update results
mktmpfile=$(mktemp /tmp/updoc-log)
tmpfile="/tmp/updoc-log"

check_system() {
  # Ignoring certain updates (Big Sur)
  # ex: sudo softwareupdate --ignore iWeb3.0.2-3.0.2
  printf "%s" "┌"
  printf "─%.0s" {1..46}
  printf "%s" "┐"
  echo
  printf "%b\n" "│ ${PENDING} Checking for macOS updates...              │"
  printf "%s" "└"
  printf "─%.0s" {1..46}
  printf "%s" "┘"
  echo
  ware=$(softwareupdate --list --verbose | grep --after-context=2 "Label")
  if [ "$ware" ]; then
    printf "%b\n" "${SUCCEEDED} macOS updates fetch successful." "  $ware" | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} macOS updates fetch unsuccessful." | tee -a "${tmpfile}"
  fi
}

check_brew() {
  printf "%s" "┌"
  printf "─%.0s" {1..46}
  printf "%s" "┐"
  echo
  printf "%b\n" "│ ${PENDING} Checking for brew updates...               │"
  printf "%s" "└"
  printf "─%.0s" {1..46}
  printf "%s" "┘"
  echo
  if brew update; then
    printf "%b\n" "${SUCCEEDED} brew update successful." | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} brew update unsuccessful." | tee -a "${tmpfile}"
  fi
  if
    brew upgrade
    brew upgrade --cask
  then
    printf "%b\n" "${SUCCEEDED} brew formulae upgraded." | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} brew formulae upgrades unsuccessful." | tee -a "${tmpfile}"
  fi
  if
    brew cleanup
  then
    printf "%b\n" "${SUCCEEDED} brew cleanup successful." | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} brew cleanup unsuccessful." | tee -a "${tmpfile}"
  fi
}

check_ohmyzsh() {
  printf "%s" "┌"
  printf "─%.0s" {1..46}
  printf "%s" "┐"
  echo
  printf "%b\n" "│ ${PENDING} Checking for oh my zsh updates...          │"
  printf "%s" "└"
  printf "─%.0s" {1..46}
  printf "%s" "┘"
  echo
  if /bin/zsh -i -c "omz update"; then
    printf "%b\n" "${SUCCEEDED} oh my zsh update successful." | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} oh my zsh update unsuccessful." | tee -a "${tmpfile}"
  fi
}

check_npm() {
  printf "%s" "┌"
  printf "─%.0s" {1..46}
  printf "%s" "┐"
  echo
  printf "%b\n" "│ ${PENDING} Checking for npm updates...                │"
  printf "%s" "└"
  printf "─%.0s" {1..46}
  printf "%s" "┘"
  echo
  if npm update; then
    printf "%b\n" "${SUCCEEDED} npm updates successful." | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} npm updates unsuccessful." | tee -a "${tmpfile}"
  fi
}

check_tools() {
  printf "%s" "┌"
  printf "─%.0s" {1..46}
  printf "%s" "┐"
  echo
  printf "%b\n" "│ ${PENDING} Checking for VimPlug updates...            │"
  printf "%s" "└"
  printf "─%.0s" {1..46}
  printf "%s" "┘"
  echo
  if
    nvim -c "PlugUpgrade" +qa
    nvim -c "PlugUpdate" +qa
  then
    printf "%b\n" "${SUCCEEDED} VimPlug updates successful." | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} VimPlug updates unsuccessful." | tee -a "${tmpfile}"
  fi
  printf "%s" "┌"
  printf "─%.0s" {1..46}
  printf "%s" "┐"
  echo
  printf "%b\n" "│ ${PENDING} Checking for tldr updates...               │"
  printf "%s" "└"
  printf "─%.0s" {1..46}
  printf "%s" "┘"
  echo
  if
    tldr --update
  then
    printf "%b\n" "${SUCCEEDED} tldr updates successful." | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} tldr updates unsuccessful." | tee -a "${tmpfile}"
  fi
}

main() {
  clear
  # If preexisting tmpfile exists, delete
  if test -f "/tmp/updoc-log"; then
    rm /tmp/updoc-log
  else
    ${mktmpfile}
  fi
  echo "${logo}"
  echo "A CLI Updates Doctor"
  check_system
  check_ohmyzsh
  check_brew
  check_npm
  check_tools
  printf "─%.0s" {1..48}
  echo
  printf "%s\n" "Done."
  clear
  printf "%b\n" "${logo}"
  printf "%b\n" "Update Results"
  printf "─%.0s" {1..48}
  echo
  cat /tmp/updoc-log
  rm /tmp/updoc-log
}

main
