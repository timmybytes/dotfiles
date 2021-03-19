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
# Cyan         0;36     Light Cyan    1;36
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

# If preexisting tmpfile exists, delete
if test -f "/tmp/temp_results"; then
  rm /tmp/temp_results
fi

# Create tmpfile to store final update results
tmpfile=$(mktemp /tmp/temp_results)

check_system() {
  # Ignoring certain updates (Big Sur)
  # ex: sudo softwareupdate --ignore iWeb3.0.2-3.0.2
  printf "─%.0s" {1..36}
  echo
  printf "${PENDING} Checking for macOS updates..."
  echo
  printf "─%.0s" {1..36}
  echo
  if softwareupdate -l; then
    printf "%s\n" "$SUCCEEDED macOS updates fetch successful." | tee -a "${tmpfile}"
  else
    printf "%s\n" "$FAILED macOS updates fetch unsuccessful." | tee -a "${tmpfile}"
  fi
}

check_brew() {
  printf "─%.0s" {1..36}
  echo
  echo -e "${PENDING} Checking for brew updates..."
  printf "─%.0s" {1..36}
  echo
  if brew update; then
    echo "${SUCCEEDED} brew updated." | tee -a "${tmpfile}"
  else
    echo "${FAILED} brew update unsuccessful." | tee -a "${tmpfile}"
  fi
  if
    brew upgrade
    brew upgrade --cask
  then
    echo "${SUCCEEDED} brew formulae upgraded." | tee -a "${tmpfile}"
  else
    echo "${FAILED} brew formulae upgrades unsuccessful." | tee -a "${tmpfile}"
  fi
  if
    brew cleanup
  then
    echo "${SUCCEEDED} brew cleanup successful." | tee -a "${tmpfile}"
  else
    echo "${FAILED} brew cleanup unsuccessful." | tee -a "${tmpfile}"
  fi
}

check_ohmyzsh() {
  printf "─%.0s" {1..36}
  echo
  echo "${PENDING} Checking for oh my zsh updates..."
  printf "─%.0s" {1..36}
  echo
  if /bin/zsh -i -c "omz update"; then
    echo "${SUCCEEDED} oh my zsh update successful." | tee -a "${tmpfile}"
  else
    echo "${FAILED} oh my zsh update unsuccessful." | tee -a "${tmpfile}"
  fi
}

check_npm() {
  printf "─%.0s" {1..36}
  echo
  echo "${PENDING} Checking for npm updates..."
  printf "─%.0s" {1..36}
  echo
  if npm update; then
    echo
    echo "${SUCCEEDED} npm updates successful." | tee -a "${tmpfile}"
  else
    echo
    echo "${FAILED} npm updates unsuccessful." | tee -a "${tmpfile}"
  fi
  printf "─%.0s" {1..36}
}

check_tools() {
  printf "─%.0s" {1..36}
  echo
  echo "${PENDING} Checking for VimPlug updates..."
  printf "─%.0s" {1..36}
  echo
  if
    nvim -c "PlugUpgrade" +qa
    nvim -c "PlugUpdate" +qa
  then
    echo
    echo "${SUCCEEDED} VimPlug updates successful." | tee -a "${tmpfile}"
  else
    echo
    echo "${FAILED} VimPlug updates unsuccessful." | tee -a "${tmpfile}"
  fi
  printf "─%.0s" {1..36}
  echo
  echo "${PENDING} Checking for tldr updates..." | tee -a "${tmpfile}"
  if
    tldr --update
  then
    echo
    echo "${SUCCEEDED} tldr updates successful." | tee -a "${tmpfile}"
  else
    echo
    echo "${FAILED} tldr updates unsuccessful." | tee -a "${tmpfile}"
  fi
}

main() {
  clear
  ${tmpfile}
  echo "${logo}"
  echo "A CLI Updates Doctor"
  echo
  printf "%s\n" "Checking for updates..."
  echo
  check_system
  check_ohmyzsh
  check_brew
  check_npm
  check_tools
  printf "─%.0s" {1..36}
  echo
  printf "%s\n" "Done."
  clear
  echo "${logo}"
  echo "${SUCCEEDED} ${FAILED} ${PENDING} Results"
  printf "─%.0s" {1..36}
  echo
  cat /tmp/temp_results
  rm /tmp/temp_results
}

main
