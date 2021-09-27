#!/usr/bin/env bash
#title          :updoc.sh
#description    :Update Doctor - check for user & system updates
#author         :Timothy Merritt
#date           :2021-02-09
#version        :0.2.0
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
NC='\033[0m' # "No Color" - resets to default

# STATUS OF AN UPDATE
PENDING="${YELLOW}●${NC}"
FAILED="${RED}𐄂${NC}"
SUCCEEDED="${GREEN}✔${NC}"

# TEMPORARY LOGFILE FOR RESULTS OUTPUT
MAKE_TMPFILE=$(mktemp /tmp/updoc-log)
TMPFILE="/tmp/updoc-log"

# ENSURES CLEAN TEMPORARY LOGFILE IS CREATED DURING EACH RUN
check_temp() {
  # If preexisting tmpfile exists, delete
  if test -f "/tmp/updoc-log"; then
    rm /tmp/updoc-log
  else
    # Create tmpfile to store final update results
    ${MAKE_TMPFILE}
  fi
}

# FANCY ASCII LOGO
LOGO="
                        ____
    __     __  ______  / __ \____  _____     __
 __/ /_   / / / / __ \/ / / / __ \/ ___/  __/ /_
/_  __/  / /_/ / /_/ / /_/ / /_/ / /__   /_  __/
 /_/     \__,_/ .___/_____/\____/\___/    /_/
             /_/
                     v0.2.0

              What's updated, Doc?
"

# WRAPS A STRING IN FANCY ASCII BOX
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

# MACOS-SPECIFIC OS UPDATES
check_system() {
  box_wrap macOS
  # Get concise name of update(s) and whether it's recommended
  local softup=$(softwareupdate --list --all | grep --after-context=2 "Label")

  if [ "$?" ]; then
    printf "%b\n" "${softup}" | tee -a "${TMPFILE}"
    printf "%b\n" "${SUCCEEDED} macOS updates fetch successful." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} macOS updates fetch unsuccessful." | tee -a "${TMPFILE}"
  fi
}

check_brew() {
  box_wrap brew

  # Update brew itself
  if brew update; then
    printf "%b\n" "${SUCCEEDED} brew update successful." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} brew update unsuccessful." | tee -a "${TMPFILE}"
  fi

  # Upgrade installed brew packages and casks
  if
    brew upgrade
    brew upgrade --cask
  then
    printf "%b\n" "${SUCCEEDED} brew formulae upgraded." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} brew formulae upgrades unsuccessful." | tee -a "${TMPFILE}"
  fi

  # Remove stale lock files, outdated downloads for all formulae and casks,
  # old versions of installed formulae, and all downloads > 120 days old.
  if
    brew cleanup
  then
    printf "%b\n" "${SUCCEEDED} brew cleanup successful." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} brew cleanup unsuccessful." | tee -a "${TMPFILE}"
  fi
}

check_ohmyzsh() {
  box_wrap ohmyzsh

  if /bin/zsh -i -c "omz update"; then
    printf "%b\n" "${SUCCEEDED} oh my zsh update successful." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} oh my zsh update unsuccessful." | tee -a "${TMPFILE}"
  fi
}

check_npm() {
  box_wrap npm

  if npm update; then
    printf "%b\n" "${SUCCEEDED} npm updates successful." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} npm updates unsuccessful." | tee -a "${TMPFILE}"
  fi
}

check_vimplug() {
  box_wrap VimPlug

  if
    nvim -c "PlugUpgrade" +qa
    nvim -c "PlugUpdate" +qa
  then
    printf "%b\n" "${SUCCEEDED} VimPlug updates successful." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} VimPlug updates unsuccessful." | tee -a "${TMPFILE}"
  fi
}

check_tldr() {
  box_wrap tldr

  if
    tldr --update
  then
    printf "%b\n" "${SUCCEEDED} tldr updates successful." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} tldr updates unsuccessful." | tee -a "${TMPFILE}"
  fi
}

results() {
  printf "─%.0s" {1..48}
  echo
  printf "%s\n" "Done."
  clear
  printf "%b\n" "${LOGO}"
  printf "%b\n" "$(date +"upDoc results for %c")"
  printf "─%.0s" {1..48}
  echo
  cat /tmp/updoc-log
  rm /tmp/updoc-log
}

main() {
  clear
  check_temp
  echo "${LOGO}"
  check_system
  check_ohmyzsh
  check_brew
  check_npm
  check_vimplug
  check_tldr
  results
}

main
