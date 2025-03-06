#!/usr/bin/env bash
# updoc.sh - Update Doctor: General Update Check Utility
# Author: Timothy Merritt (Refactored by ChatGPT)
# Date: 2025-03-06
# Version: 0.4.4

# Set strict error handling
set -euo pipefail

#============================================================================
# Global Variables & Color Codes
#============================================================================
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

PENDING="${YELLOW}●${NO_COLOR}"
FAILED="${RED}𐄂${NO_COLOR}"
SUCCEEDED="${GREEN}✔${NO_COLOR}"

# Determine a normalized temporary directory (strip any trailing slash)
LOGDIR="${TMPDIR:-/tmp}"
LOGDIR="${LOGDIR%/}"
LOGFILE=$(mktemp "$LOGDIR/updoc-log.XXXXXX")
trap "rm -f \"$LOGFILE\"" EXIT

# Configuration file path and update options placeholder
CONFIG_FILE="$HOME/.updoc_config"
UPDATE_OPTIONS=""

# Global summary associative array
declare -A SUMMARY

# ASCII Logo (with current version)
LOGO=$(
  cat <<'EOF'
                        ____
    __     __  ______  / __ \____  _____     __
 __/ /_   / / / / __ \/ / / / __ \/ ___/  __/ /_
/_  __/  / /_/ / /_/ / /_/ / /_/ / /__   /_  __/
 /_/     \__,_/ .___/_____/\____/\___/    /_/
             /_/
                     v0.4.4

              What's updated, Doc?
EOF
)

# Default verbosity (0: silent, 1: verbose)
verbose=0

#============================================================================
# Helper Functions
#============================================================================

# Check if a command exists in the current PATH.
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Run a command, piping its output live (via tee) to both stdout and the log.
run_command() {
  local description="$1"
  shift
  echo "🞧 $description"
  if "$@" 2>&1 | tee -a "$LOGFILE"; then
    log "${SUCCEEDED} ${description} successful."
    return 0
  else
    log "${FAILED} ${description} failed. See above for details."
    return 1
  fi
}

# Log messages with a timestamp to the log file and (if verbose) to stdout.
log() {
  local msg="$1"
  local timestamp
  timestamp=$(date +"%H:%M:%S")
  echo -e "[$timestamp] $msg" >>"$LOGFILE"
  if [ "$verbose" -eq 1 ]; then
    echo -e "[$timestamp] $msg"
  fi
}

# Display a status message inside an ASCII box if the 'boxes' command is available.
box_wrap() {
  local app="$1"
  local label="${2:-Checking for ${app} updates...}"
  echo ""
  if command_exists boxes; then
    printf "%b %s\n" "${PENDING}" "${label}" | boxes -d ansi-rounded -p h2 -a hc -s 48
  else
    printf "%b %s\n" "${PENDING}" "${label}"
  fi
}

#============================================================================
# CLI-based Configuration Menu
#============================================================================
configure_menu() {
  echo -e "$LOGO"
  echo "Welcome to the upDoc configuration wizard!"
  echo "Select the update checks you want to run by entering the corresponding numbers separated by commas."
  echo "Available options:"
  echo "1) macOS"
  echo "2) brew"
  echo "3) oh‑my‑zsh"
  echo "4) npm"
  echo "5) VimPlug"
  echo "6) tldr"
  echo "7) VSCode"
  echo "8) apt (Linux)"
  echo "9) pip"
  echo ""
  read -rp "Enter your choices (e.g., 1,3,5): " choices

  local selected=()
  IFS=',' read -ra opts <<<"$choices"
  for opt in "${opts[@]}"; do
    case "$(echo "$opt" | tr -d ' ')" in
    1) selected+=("macos") ;;
    2) selected+=("brew") ;;
    3) selected+=("ohmyzsh") ;;
    4) selected+=("npm") ;;
    5) selected+=("vimplug") ;;
    6) selected+=("tldr") ;;
    7) selected+=("vscode") ;;
    8) selected+=("apt") ;;
    9) selected+=("pip") ;;
    *) echo "Invalid option: $opt" ;;
    esac
  done

  if [ "${#selected[@]}" -eq 0 ]; then
    echo "No valid options selected. Exiting configuration."
    exit 1
  fi

  UPDATE_OPTIONS="${selected[*]}"
  echo "UPDATE_OPTIONS=\"$UPDATE_OPTIONS\"" >"$CONFIG_FILE"
  echo "Configuration saved to $CONFIG_FILE."
  echo "Selected update checks: ${selected[*]}"
  exit 0
}

#============================================================================
# Usage Function & Argument Parsing
#============================================================================
usage() {
  echo "Usage: ${0##*/} [-h] [-v] [--configure]"
  echo "  -h            Show help message"
  echo "  -v            Enable verbose output"
  echo "  --configure   Run configuration setup"
}

# First, check for any long options before getopts
for arg in "$@"; do
  if [[ "$arg" == "--configure" ]]; then
    configure_menu
    exit 0
  fi
done

# Process short options
while getopts "hv" opt; do
  case ${opt} in
  h)
    usage
    exit 0
    ;;
  v)
    verbose=1
    ;;
  *)
    usage
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

#============================================================================
# Load Configuration
#============================================================================
if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
  # Convert the UPDATE_OPTIONS string into an array
  selected_updates=($UPDATE_OPTIONS)
else
  echo "No configuration found. Run '$0 --configure' to set up your update checks."
  exit 1
fi

#============================================================================
# Update Check Functions
#============================================================================

# macOS updates using softwareupdate
check_system() {
  box_wrap "macOS" "Checking for macOS updates..."
  if command_exists softwareupdate; then
    echo "🞧 Fetching macOS updates..."
    local tmpfile
    tmpfile=$(mktemp)
    if softwareupdate --list --all 2>&1 | tee -a "$LOGFILE" | tee "$tmpfile"; then
      local condensed
      condensed=$(awk '
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
        }' "$tmpfile")
      echo -e "$condensed" | tee -a "$LOGFILE"
      log "${SUCCEEDED} macOS updates fetch successful."
      SUMMARY["macos"]="Success"
    else
      log "${FAILED} macOS updates fetch unsuccessful. See above for details."
      SUMMARY["macos"]="Failure"
    fi
    rm -f "$tmpfile"
  else
    log "${FAILED} softwareupdate command not found."
    SUMMARY["macos"]="Not Installed"
  fi
}

# Homebrew update checks
check_brew() {
  box_wrap "brew" "Checking for Homebrew updates..."
  if command_exists brew; then
    echo "🞧 Running Homebrew update checks..."
    local brew_status=0
    if ! run_command "brew update" brew update; then brew_status=1; fi
    if ! run_command "brew upgrade" brew upgrade; then brew_status=1; fi
    if ! run_command "brew upgrade --cask" brew upgrade --cask; then brew_status=1; fi

    local outdated_casks
    outdated_casks=$(brew outdated --cask | cut -f1)
    if [ -n "$outdated_casks" ]; then
      while IFS= read -r cask; do
        run_command "Reinstall cask: $cask" brew reinstall --cask "$cask" || true
      done <<<"$outdated_casks"
    fi

    run_command "brew cleanup" bash -c 'brew doctor && brew missing && brew cleanup -s' || true

    if [ $brew_status -eq 0 ]; then
      SUMMARY["brew"]="Success"
    else
      SUMMARY["brew"]="Failure"
    fi
  else
    log "${FAILED} brew is not installed."
    SUMMARY["brew"]="Not Installed"
  fi
}

# oh-my-zsh update checks
check_ohmyzsh() {
  box_wrap "ohmyzsh" "Checking for oh‑my‑zsh updates..."
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "🞧 Running oh‑my‑zsh update..."
    if run_command "oh‑my‑zsh update" /bin/zsh -ic "omz update"; then
      SUMMARY["ohmyzsh"]="Success"
    else
      SUMMARY["ohmyzsh"]="Failure"
    fi
  else
    log "${FAILED} oh‑my‑zsh not found in \$HOME/.oh-my-zsh."
    SUMMARY["ohmyzsh"]="Not Installed"
  fi
}

# npm update checks
check_npm() {
  box_wrap "npm" "Checking for npm updates..."
  if command_exists npm; then
    echo "🞧 Running npm update checks..."
    local npm_status=0
    if ! run_command "npm update" npm update; then npm_status=1; fi
    if ! run_command "npm upgrade to latest" npm install npm@latest -g; then npm_status=1; fi
    run_command "npm outdated check" npm outdated -g --depth=0 || true
    if [ $npm_status -eq 0 ]; then
      SUMMARY["npm"]="Success"
    else
      SUMMARY["npm"]="Failure"
    fi
  else
    log "${FAILED} npm is not installed."
    SUMMARY["npm"]="Not Installed"
  fi
}

# VimPlug update checks using Neovim in headless mode
check_vimplug() {
  box_wrap "VimPlug" "Checking for VimPlug updates..."
  if command_exists nvim; then
    echo "🞧 Running VimPlug update checks..."
    if run_command "VimPlug upgrade" nvim --headless -c "PlugUpgrade" -c "qa"; then
      if run_command "VimPlug update" nvim --headless -c "PlugUpdate" -c "qa"; then
        SUMMARY["vimplug"]="Success"
      else
        SUMMARY["vimplug"]="Failure"
      fi
    else
      SUMMARY["vimplug"]="Failure"
    fi
  else
    log "${FAILED} nvim is not installed."
    SUMMARY["vimplug"]="Not Installed"
  fi
}

# tldr update checks
check_tldr() {
  box_wrap "tldr" "Checking for tldr updates..."
  if command_exists tldr; then
    echo "🞧 Running tldr update..."
    if run_command "tldr update" tldr --update; then
      SUMMARY["tldr"]="Success"
    else
      SUMMARY["tldr"]="Failure"
    fi
  else
    log "${FAILED} tldr is not installed."
    SUMMARY["tldr"]="Not Installed"
  fi
}

# VSCode extension update checks
check_vscode() {
  box_wrap "VSCode" "Checking for VSCode extension updates..."
  if command_exists code; then
    echo "🞧 Running VSCode extensions update..."
    if run_command "VSCode extensions update" code --update-extensions; then
      SUMMARY["vscode"]="Success"
    else
      SUMMARY["vscode"]="Failure"
    fi
  else
    log "${FAILED} VSCode (code) command not found."
    SUMMARY["vscode"]="Not Installed"
  fi
}

# apt update checks (for Debian-based systems)
check_apt() {
  box_wrap "apt" "Checking for apt updates..."
  if command_exists apt; then
    echo "🞧 Running apt update checks..."
    run_command "apt update" sudo apt update || true
    run_command "apt upgrade" sudo apt upgrade -y || true
    run_command "apt autoremove" sudo apt autoremove -y || true
    SUMMARY["apt"]="Success"
  else
    log "${FAILED} apt is not available."
    SUMMARY["apt"]="Not Installed"
  fi
}

# pip update checks (for Python packages)
check_pip() {
  box_wrap "pip" "Checking for pip updates..."
  if command_exists pip; then
    echo "🞧 Running pip update checks..."
    run_command "pip list outdated" pip list --outdated || true
    run_command "pip upgrade pip" pip install --upgrade pip || true
    SUMMARY["pip"]="Success"
  else
    log "${FAILED} pip is not installed."
    SUMMARY["pip"]="Not Installed"
  fi
}

#============================================================================
# Final Results & Main Execution
#============================================================================
results() {
  local line
  line=$(printf '─%.0s' $(seq 1 48))
  echo "$line"
  echo "Update Summary:"
  for update in "${selected_updates[@]}"; do
    printf "  %-8s : %s\n" "$update" "${SUMMARY[$update]}"
  done
  echo "$line"
  echo "For full details, please check the log file:"
  echo "  $LOGFILE"
}

main() {
  clear
  echo -e "$LOGO"
  for update in "${selected_updates[@]}"; do
    case "$update" in
    macos) check_system ;;
    brew) check_brew ;;
    ohmyzsh) check_ohmyzsh ;;
    npm) check_npm ;;
    vimplug) check_vimplug ;;
    tldr) check_tldr ;;
    vscode) check_vscode ;;
    apt) check_apt ;;
    pip) check_pip ;;
    *) log "Unknown update option: $update" ;;
    esac
  done
  results
}

main
