#!/usr/bin/env bash
# updoc.sh - Update Doctor: Check for user & system updates
# Author: Timothy Merritt
# Date: 2025-02-14
# Version: 0.3.1

# Set strict error handling
set -euo pipefail

#============================================================================
# Global Variables
#============================================================================

# Color Codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

# Status Icons
PENDING="${YELLOW}●${NO_COLOR}"
FAILED="${RED}𐄂${NO_COLOR}"
SUCCEEDED="${GREEN}✔${NO_COLOR}"

# Create a temporary logfile in a portable location; cleanup on exit.
LOGFILE=$(mktemp "${TMPDIR:-/tmp}/updoc-log.XXXXXX")
trap 'rm -f "${LOGFILE}"' EXIT

# ASCII Logo
LOGO=$(
  cat <<'EOF'
                        ____
    __     __  ______  / __ \____  _____     __
 __/ /_   / / / / __ \/ / / / __ \/ ___/  __/ /_
/_  __/  / /_/ / /_/ / /_/ / /_/ / /__   /_  __/
 /_/     \__,_/ .___/_____/\____/\___/    /_/
             /_/
                     v0.2.1

              What's updated, Doc?
EOF
)

# Default verbosity (0: silent, 1: verbose)
verbose=0

#============================================================================
# Option Parsing
#============================================================================

usage() {
  echo "Usage: ${0##*/} [-h] [-v]"
  echo "  -h  Show this help message"
  echo "  -v  Enable verbose output"
}

while getopts "hv" opt; do
  case ${opt} in
  h)
    usage
    exit 0
    ;;
  v) verbose=1 ;;
  *)
    usage
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

#============================================================================
# Utility Functions
#============================================================================

# Log messages to logfile and, if verbose is enabled, to stdout.
log() {
  local msg="$1"
  echo -e "$msg" >>"${LOGFILE}"
  if [ "${verbose}" -eq 1 ]; then
    echo -e "$msg"
  fi
}

# Draw a fancy ASCII box with a status message.
box_wrap() {
  local app="$1"
  local label="${2:-Checking for ${app} updates...}"
  # Print an empty line for spacing
  echo ""
  printf "%b %s%s \n" "${PENDING}" "${label}" | boxes -d ansi-rounded -p h2 -a hc -s 48
}

#============================================================================
# Update Check Functions
#============================================================================

check_system() {
  box_wrap "macOS" "Checking for macOS updates..."
  if command -v softwareupdate >/dev/null 2>&1; then
    local output condensed
    if output=$(softwareupdate --list --all 2>&1); then
      # Condenses the overly verbose macos update output to a more readable format
      # E.g., "* Update: macOS Big Sur 11.7.9 - Recommended - Restart Required"
      condensed=$(echo "${output}" | awk '
        /^\* Label:/ {
          label = $0;
          sub(/^\* Label: /, "", label);
          getline details;
          recommended = "";
          action = "";
          n = split(details, fields, ",");
          for (i = 1; i <= n; i++) {
            if (fields[i] ~ /Recommended:/) {
              gsub(/.*Recommended: */, "", fields[i]);
              if (fields[i] ~ /YES/) { recommended = "Recommended" }
            }
            if (fields[i] ~ /Action:/) {
              gsub(/.*Action: */, "", fields[i]);
              if (fields[i] ~ /restart/) { action = "Restart Required" }
            }
          }
          printf "* Update: %s", label;
          if (recommended != "") {
            printf " - %s", recommended;
          }
          if (action != "") {
            printf " - %s", action;
          }
          printf "\n";
        }')
      echo -e "${condensed}" | tee -a "${LOGFILE}"
      log "${SUCCEEDED} macOS updates fetch successful."
    else
      log "${FAILED} macOS updates fetch unsuccessful."
    fi
  else
    log "${FAILED} softwareupdate command not found."
  fi
}

check_brew() {
  box_wrap "brew" "Checking for Homebrew updates..."
  if command -v brew >/dev/null 2>&1; then
    local brew_status=0

    if brew update; then
      log "${SUCCEEDED} brew update successful."
    else
      log "${FAILED} brew update unsuccessful."
      brew_status=1
    fi

    if brew upgrade; then
      log "${SUCCEEDED} brew formulae upgraded."
    else
      log "${FAILED} brew formulae upgrades unsuccessful."
      brew_status=1
    fi

    if brew upgrade --cask; then
      log "${SUCCEEDED} brew casks upgraded."
    else
      log "${FAILED} brew casks upgrades unsuccessful."
      brew_status=1
    fi

    # Update outdated casks (using a portable loop instead of GNU-specific xargs -r)
    local outdated_casks
    outdated_casks=$(brew outdated --cask | cut -f1)
    if [ -n "$outdated_casks" ]; then
      while IFS= read -r cask; do
        if brew reinstall --cask "$cask"; then
          log "${SUCCEEDED} Reinstalled cask: $cask"
        else
          log "${FAILED} Failed to reinstall cask: $cask"
          brew_status=1
        fi
      done <<<"$outdated_casks"
    fi

    if brew doctor && brew missing && brew cleanup -s; then
      log "${SUCCEEDED} brew cleanup successful."
    else
      log "${FAILED} brew cleanup unsuccessful."
      brew_status=1
    fi

    if [ $brew_status -eq 0 ]; then
      log "${SUCCEEDED} All brew updates successful."
    else
      log "${FAILED} Some brew updates failed."
    fi
  else
    log "${FAILED} brew is not installed."
  fi
}

check_ohmyzsh() {
  box_wrap "ohmyzsh" "Checking for Oh My Zsh updates..."
  # Use the default ZSH directory or fallback to ~/.oh-my-zsh
  if /bin/zsh -i -c "omz update"; then
    log "${SUCCEEDED} Oh My Zsh update successful."
  else
    log "${FAILED} Oh My Zsh update unsuccessful."
  fi
}

check_npm() {
  box_wrap "npm" "Checking for npm updates..."
  if command -v npm >/dev/null 2>&1; then
    local npm_status=0
    if npm update; then
      log "${SUCCEEDED} npm update successful."
    else
      log "${FAILED} npm update unsuccessful."
      npm_status=1
    fi

    if npm install npm@latest -g; then
      log "${SUCCEEDED} npm version updated to latest."
    else
      log "${FAILED} npm version update unsuccessful."
      npm_status=1
    fi

    if npm outdated -g --depth=0; then
      log "${SUCCEEDED} npm outdated packages fetched."
    else
      log "${FAILED} npm outdated packages fetch unsuccessful."
      npm_status=1
    fi

    if [ $npm_status -eq 0 ]; then
      log "${SUCCEEDED} All npm updates successful."
    else
      log "${FAILED} Some npm updates failed."
    fi
  else
    log "${FAILED} npm is not installed."
  fi
}

check_vimplug() {
  box_wrap "VimPlug" "Checking for VimPlug updates..."
  if command -v nvim >/dev/null 2>&1; then
    if nvim -c "PlugUpgrade" +qa && nvim -c "PlugUpdate" +qa; then
      log "${SUCCEEDED} VimPlug upgrade successful."
    else
      log "${FAILED} VimPlug upgrade unsuccessful."
    fi
  else
    log "${FAILED} nvim is not installed."
  fi
}

check_tldr() {
  box_wrap "tldr" "Checking for tldr updates..."
  if command -v tldr >/dev/null 2>&1; then
    if tldr --update; then
      log "${SUCCEEDED} tldr updates successful."
    else
      log "${FAILED} tldr updates unsuccessful."
    fi
  else
    log "${FAILED} tldr is not installed."
  fi
}

check_vscode() {
  box_wrap "VSCode" "Checking for VSCode extension updates..."
  if command -v code >/dev/null 2>&1; then
    if code --update-extensions; then
      log "${SUCCEEDED} VSCode extensions update successful."
    else
      log "${FAILED} VSCode extensions update unsuccessful."
    fi
  else
    log "${FAILED} VSCode (code) command not found."
  fi
}

#============================================================================
# Final Results & Main Execution
#============================================================================

results() {
  local line
  line=$(printf '─%.0s' $(seq 1 48))
  echo "${line}"
  echo "Done."
  # clear
  echo -e "${LOGO}"
  echo -e "$(date +"upDoc results for %c")"
  echo "${line}"
  cat "${LOGFILE}"
}

main() {
  clear
  echo -e "${LOGO}"
  check_system
  check_ohmyzsh
  check_brew
  check_npm
  check_vimplug
  check_tldr
  check_vscode
  results
}

main
