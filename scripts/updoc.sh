#!/usr/bin/env bash
#title          :updoc.sh
#description    :Update Doctor - check for user & system updates
#author         :Timothy Merritt
#date           :2021-02-09
#version        :0.2.1
#usage          :./updoc.sh
#notes          :
#bash_version   :5.0.18(1)-release
#============================================================================
# Color codes for update status icons
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

# Status of an update
PENDING="${YELLOW}●${NO_COLOR}"
FAILED="${RED}𐄂${NO_COLOR}"
SUCCEEDED="${GREEN}✔${NO_COLOR}"

# Temporary logfile for results output - deleted after each run
MAKE_TMPFILE=$(mktemp /tmp/updoc-log)
TMPFILE="/tmp/updoc-log"

# Ensures clean temporary logfile is created during each run
check_temp() {
  # If preexisting tmpfile exists, delete
  if test -f "/tmp/updoc-log"; then
    rm /tmp/updoc-log
  else
    # Create tmpfile to store final update results
    ${MAKE_TMPFILE}
  fi
}

LOGO="
                        ____
    __     __  ______  / __ \____  _____     __
 __/ /_   / / / / __ \/ / / / __ \/ ___/  __/ /_
/_  __/  / /_/ / /_/ / /_/ / /_/ / /__   /_  __/
 /_/     \__,_/ .___/_____/\____/\___/    /_/
             /_/
                     v0.2.1

              What's updated, Doc?
"
# Wraps a string in fancy ASCII box (the hard way)
# TODO: Add simpler/automated box drawing
function box_wrap() {
  # Limit app name to prevent overflowing
  app=$(printf "%b" "${@}" | cut -c 1-18)
  # Get length of app name
  app_len=$(printf "%b" "${#app}")
  # Calculate whitespace needed to maintain box shape
  get_whitespace=$((18 - app_len))
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

# Check for macOS-specific OS updates
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

# Check for brew (macOS package manager) updates
check_brew() {
  box_wrap brew

  # Update brew itself
  if brew update; then
    printf "%b\n" "${SUCCEEDED} brew update successful." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} brew update unsuccessful." | tee -a "${TMPFILE}"
  fi

  # Upgrade installed brew packages and casks (apps)
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
  if brew cleanup; then
    printf "%b\n" "${SUCCEEDED} brew cleanup successful." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} brew cleanup unsuccessful." | tee -a "${TMPFILE}"
  fi
}

# Check for zsh framework Oh My Zsh updates
check_ohmyzsh() {
  box_wrap ohmyzsh

  if /bin/zsh -i -c "omz update --unattended"; then
    printf "%b\n" "${SUCCEEDED} oh my zsh update successful." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} oh my zsh update unsuccessful." | tee -a "${TMPFILE}"
  fi
}

# Check for Node package manager updates
check_npm() {
  box_wrap npm

  if npm update; then
    printf "%b\n" "${SUCCEEDED} npm updates successful." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} npm updates unsuccessful." | tee -a "${TMPFILE}"
  fi
}

# Check for Vim package manager VimPlug updates
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

# Check for newly indexed command TLDRs
check_tldr() {
  box_wrap tldr

  if tldr --update; then
    printf "%b\n" "${SUCCEEDED} tldr updates successful." | tee -a "${TMPFILE}"
  else
    printf "%b\n" "${FAILED} tldr updates unsuccessful." | tee -a "${TMPFILE}"
  fi
}

# Print formatted final results
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

  # TODO: If there are recommended updates, persist reminder in tempfile for next run
  # if grep -q "Label" $TMPFILE; then
  #   box_wrap There are recommended updates to install
  # fi

  rm /tmp/updoc-log
}

main() {
  # Clear the screen
  clear
  # Check for tempfile and/or create one
  check_temp
  # Show the pretty ASCII logo
  echo "${LOGO}"
  # Check for updates
  check_system
  check_ohmyzsh
  check_brew
  check_npm
  check_vimplug
  check_tldr
  # Show the results
  results
}

main
