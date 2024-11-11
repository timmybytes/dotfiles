#!/usr/bin/env bash
#title          :updoc.sh
#description    :Update Doctor - check for user & system updates
#author         :Timothy Merritt
#date           :2021-02-09
#version        :0.3.1
#usage          :./updoc.sh
#notes          :
#bash_version   :5.0.18(1)-release
#============================================================================

# TODO: Add support for getopts, config file, and install script
# TODO: Add yarn cache clean, verify brew's cleaning cache files

#============================================================================
# Global Variables
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

# Arrays of personal and work git repositories
PERSONAL_REPOS="$HOME/Projects/Repos"
WORK_REPOS="$HOME/Work"

#============================================================================
# Option Parsing
#============================================================================

# Implementing getopts for future use
# while getopts ":hv" option; do
# case "${option}" in
# h)
# echo "Usage: ${0} [-h] [-v] [-u <tool_name>]"
# echo "-h: Display this help message."
# echo "-v: Enable verbose output."
# echo "-u: Update a specific tool only (e.g., npm, brew)."
# exit 0
# ;;
# v)
# verbose=1
# ;;
# u)
# update_specific_tool="${OPTARG}"
# ;;
# \?)
# echo "Invalid option: -${OPTARG}" >&2
# exit 1
# ;;
# :)
# echo "Option -${OPTARG} requires an argument." >&2
# exit 1
# ;;
# esac
# done

#============================================================================
# Functions
#============================================================================

# Ensures clean temporary logfile is created during each run
check_temp_file() {
  # If preexisting tmpfile exists, delete
  if test -f "/tmp/updoc-log"; then
    rm /tmp/updoc-log
  else
    # Create tmpfile to store final update results
    ${MAKE_TMPFILE}
  fi
}

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

  local softup
  softup=$(softwareupdate --list --all | grep --after-context=2 "Label")

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

  # A workaround for
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

  # Run Neovim commands for
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

# Check git repos for uncommitted changes, unpushed commits, and changes to remote branches to be pulled
check_git() {
  box_wrap git
  TEMP_FILE=$(mktemp) # Temporary file to store results
  ERROR_FLAG=0

  # Helper function to check an individual repository
  check_repo() {
    local repo_path=$1
    cd "$repo_path" || return 1

    # Verify if the repository has any commits
    if ! git rev-parse HEAD >/dev/null 2>&1; then
      echo "Repo: $repo_path" >>"$TEMP_FILE"
      echo "  No commits in this repository." >>"$TEMP_FILE"
      return 0
    fi

    # Check for uncommitted changes
    local uncommitted
    uncommitted=$(git status --porcelain)

    # Check for unpushed commits
    local branch_name
    branch_name=$(git rev-parse --abbrev-ref HEAD)
    local unpushed=""
    if git rev-parse --verify "origin/$branch_name" >/dev/null 2>&1; then
      unpushed=$(git log "origin/$branch_name..HEAD" --oneline)
    fi

    # Check if there are remote changes to pull
    local pull_needed
    pull_needed=$(git fetch --dry-run 2>&1)

    # Append findings to temp file if there are relevant changes
    if [[ -n "$uncommitted" || -n "$unpushed" || -n "$pull_needed" ]]; then
      echo "Repo: $repo_path" >>"$TEMP_FILE"
      [[ -n "$uncommitted" ]] && echo "  Uncommitted changes present." >>"$TEMP_FILE"
      [[ -n "$unpushed" ]] && echo "  Unpushed commits:" >>"$TEMP_FILE" && echo "$unpushed" >>"$TEMP_FILE"
      [[ -n "$pull_needed" ]] && echo "  Remote changes to pull." >>"$TEMP_FILE"
      echo >>"$TEMP_FILE" # Add extra line for readability
    fi
  }

  # Helper function to process repositories within a given directory
  process_directory() {
    local dir_path=$1
    local group_label=$2

    echo "Checking $group_label repositories in $dir_path..."

    # Find Git repos, excluding any directory containing "Archive" (case insensitive)
    find "$dir_path" -type d -name ".git" -prune ! -path "*[Aa]rchive*" | while IFS= read -r git_dir; do
      local repo_path
      repo_path=$(dirname "$git_dir")
      check_repo "$repo_path" || ERROR_FLAG=1
    done
  }

  # Process personal and work directories
  process_directory "$PERSONAL_REPOS" "Personal"
  process_directory "$WORK_REPOS" "Work"

  # Display results
  if [[ -s $TEMP_FILE ]]; then
    echo "Recommended updates:"
    cat "$TEMP_FILE"
  else
    echo "No recommended updates found."
  fi

  # Persist reminder if there were updates found
  [[ -s $TEMP_FILE ]] && cp "$TEMP_FILE" /path/to/last_check_tempfile

  # Handle any errors encountered during repo checks
  if [[ $ERROR_FLAG -ne 0 ]]; then
    echo "Error: Unable to check some git repos."
  fi

  rm -f "$TEMP_FILE" # Clean up temporary file
}

# WIP
# TODO: Add better VPN handling
# TODO: Check for VSCode updates
check_vscode() {
  # Check for VSCode updates
  box_wrap VSCode
  if mullvad status | grep "Connected"; then
    printf "%b\n" "${SUCCEEDED} VPN disconnected for VSCode updates."
    if code-insiders --update-extensions; then
      printf "%b\n" "${SUCCEEDED} VSCode extensions updates successful." | tee -a "${TMPFILE}"
    else
      printf "%b\n" "${FAILED} VSCode extensions updates unsuccessful." | tee -a "${TMPFILE}"
    fi

    # Compare if updated extensions differ from ~/.dotfiles/vscode/extensions.txt, if so, update extensions.txt
    if code-insiders --list-extensions >~/.dotfiles/vscode/extensions.txt; then
      printf "%b\n" "${SUCCEEDED} dotfiles' VSCode extensions list updated." | tee -a "${TMPFILE}"
      # Print reminder to commit and push updated extensions.txt
      printf "%b\n" "  → → → Remember to commit and push updated .dotfiles to GitHub!" | tee -a "${TMPFILE}"
    else
      printf "%b\n" "${FAILED} dotfiles' VSCode extensions list update unsuccessful." | tee -a "${TMPFILE}"
    fi
  fi

  # Ensure VPN is reconnected before finishing function
  if mullvad status | grep "Disconnected"; then
    mullvad connect
  fi
}

# TODO: Add crontab support for scheduled updates

# Print formatted final results
results() {
  printf "─%.0s" {1..48}
  echo
  printf "%s\n" "Done."
  # clear
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

#============================================================================
# Main Execution
#============================================================================

main() {
  # Clear the screen
  clear
  # Check for tempfile and/or create one
  check_temp_file
  # Show the pretty ASCII logo
  echo "${LOGO}"
  # Check for updates
  # check_system
  # check_ohmyzsh
  # check_brew
  # check_npm
  # check_vimplug
  # check_tldr
  # check_vscode
  check_git
  # Show the results
  results
}

main
