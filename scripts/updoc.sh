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
# COLOR REFERENCE
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
SUCCEEDED="${GREEN}✔${NC}"

mktmpfile=$(mktemp /tmp/updoc-log)
tmpfile="/tmp/updoc-log"

logo="
                        ____
    __     __  ______  / __ \____  _____     __
 __/ /_   / / / / __ \/ / / / __ \/ ___/  __/ /_
/_  __/  / /_/ / /_/ / /_/ / /_/ / /__   /_  __/
 /_/     \__,_/ .___/_____/\____/\___/    /_/
             /_/

   What's up with your software updates, Doc?
"

check_temp() {
  # If preexisting tmpfile exists, delete
  if test -f "/tmp/updoc-log"; then
    rm /tmp/updoc-log
  else
    # Create tmpfile to store final update results
    ${mktmpfile}
  fi
}

function box_wrap() {
  # Limit app name to prevent overflowing
  app=$(printf "%b" "${@}" | cut -c 1-18)
  # Get length of app name
  app_len=$(printf "%b" "${#app}")
  # Calculate whitespace needed to maintain box shape
  get_whitespace=$((18 - ${app_len}))
  whitespace=$(printf "%${get_whitespace}s\n")
  # Print the box!
  printf "%s" "┌"
  printf "─%.0s" {1..46}
  printf "%s" "┐"
  echo
  printf "%b\n" "│ ${PENDING} Checking for ${app} updates...${whitespace} │"
  printf "%s" "└"
  printf "─%.0s" {1..46}
  printf "%s\n" "┘"
}

check_system() {
  box_wrap macOS
  # TODO: Discern between "No new software available" and specifically listed packages, receiving exit 0 for either.

  # Run as background process and wait for results --WIP
  # softwareupdate --list &
  # process_id=$!
  # wait $process_id
  # echo "Exit status: $?"

  ware=$(softwareupdate --list)
  # ware_specific=$($ware | grep --after-context=2 "Label")
  if [ "$?" ]; then
    # parse_ware=$("$ware" | grep -e "No" -e "Label" | tr -d '\n')
    printf "%b\n" "${SUCCEEDED} macOS updates fetch successful." | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} macOS updates fetch unsuccessful." | tee -a "${tmpfile}"
  fi
}

check_brew() {
  box_wrap brew
  # TODO: Less verbose output
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
  box_wrap ohmyzsh
  # TODO: Less verbose output
  if /bin/zsh -i -c "omz update"; then
    printf "%b\n" "${SUCCEEDED} oh my zsh update successful." | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} oh my zsh update unsuccessful." | tee -a "${tmpfile}"
  fi
}

check_npm() {
  box_wrap npm
  if npm update; then
    printf "%b\n" "${SUCCEEDED} npm updates successful." | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} npm updates unsuccessful." | tee -a "${tmpfile}"
  fi
}

check_vimplug() {
  box_wrap VimPlug
  if
    nvim -c "PlugUpgrade" +qa
    nvim -c "PlugUpdate" +qa
  then
    printf "%b\n" "${SUCCEEDED} VimPlug updates successful." | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} VimPlug updates unsuccessful." | tee -a "${tmpfile}"
  fi
}

check_tldr() {
  box_wrap tldr
  if
    tldr --update
  then
    printf "%b\n" "${SUCCEEDED} tldr updates successful." | tee -a "${tmpfile}"
  else
    printf "%b\n" "${FAILED} tldr updates unsuccessful." | tee -a "${tmpfile}"
  fi
}

results() {
  # TODO: Add box around results
  printf "─%.0s" {1..48}
  echo
  printf "%s\n" "Done."
  clear
  printf "%b\n" "${logo}"
  printf "%b\n" "$(date +"upDoc results for %c")"
  printf "─%.0s" {1..48}
  echo
  cat /tmp/updoc-log
  rm /tmp/updoc-log
}

main() {
  clear
  check_temp
  echo "${logo}"
  check_system
  check_ohmyzsh
  check_brew
  check_npm
  check_vimplug
  check_tldr
  results
}

main
