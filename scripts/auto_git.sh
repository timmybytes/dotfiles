#!/usr/bin/env bash
#title          :auto_git.sh
#description    :Automated git repo commits and pushes
#author         :Timothy Merritt
#date           :2024-11-22
#version        :0.1
#usage          :./auto_git.sh
#notes          :
#bash_version   :5.1.8(1)-release
#============================================================================

# Enable strict mode
set -euo pipefail
IFS=$'\n\t'

# Set the path to the git repo
GIT_REPO_PATH="/path/to/your/repo"

# Set the branch name
BRANCH_NAME="main"

# Set the path to the log files
LOG_DIR="/path/to/your/logs"
LOG_FILE="$LOG_DIR/auto_git.log"
ERROR_LOG_FILE="$LOG_DIR/auto_git_error.log"

# Set environment variables for launchd
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Function to log messages
log_message() {
  echo "$(date "+%Y-%m-%d %H:%M:%S") - INFO: $1" | tee -a "$LOG_FILE"
}

# Function to log errors
log_error() {
  echo "$(date "+%Y-%m-%d %H:%M:%S") - ERROR: $1" | tee -a "$ERROR_LOG_FILE" >&2
}

# Function to send error notifications (optional)
send_error_notification() {
  # Implement your notification method here (e.g., email or system notification)
  # Example using osascript for macOS notifications:
  osascript -e 'display notification "'"$1"'" with title "Auto Git Script Error"'
}

# Function to check network connectivity
check_network() {
  if ! ping -c 1 -W 5 github.com &>/dev/null; then
    log_error "Network is unreachable. Cannot connect to GitHub."
    send_error_notification "Network is unreachable. Cannot connect to GitHub."
    exit 1
  fi
}

# Function to prevent overlapping runs
create_lock() {
  LOCKFILE="/tmp/auto_git.lock"
  exec 200>"$LOCKFILE"
  flock -n 200 || {
    log_message "Script is already running."
    exit 1
  }
  # Remove lock file on exit
  trap 'rm -f "$LOCKFILE"' EXIT
}

# Function to perform git operations with error handling
check_commit_pull_push() {
  if cd "$GIT_REPO_PATH"; then
    log_message "Switched to repository at $GIT_REPO_PATH"

    # Check for unstaged changes
    if [[ -n "$(git status --porcelain)" ]]; then
      git add -A
      git commit -m "Auto commit at $(date "+%Y-%m-%d %H:%M:%S")" || log_message "No changes to commit"
    else
      log_message "No changes to commit"
    fi

    # Check network before pulling/pushing
    check_network

    # Pull latest changes
    if git pull origin "$BRANCH_NAME" --rebase; then
      log_message "Pulled latest changes successfully"
    else
      log_error "Failed to pull changes from remote"
      send_error_notification "Failed to pull changes from remote"
      exit 1
    fi

    # Push committed changes
    if git push origin "$BRANCH_NAME"; then
      log_message "Pushed changes to remote successfully"
    else
      log_error "Failed to push changes to remote"
      send_error_notification "Failed to push changes to remote"
      exit 1
    fi
  else
    log_error "Failed to access repository at $GIT_REPO_PATH"
    send_error_notification "Failed to access repository at $GIT_REPO_PATH"
    exit 1
  fi
}

# Main function
main() {
  create_lock
  log_message "Starting auto git check"
  if check_commit_pull_push; then
    log_message "Auto git operations completed successfully"
  else
    log_error "Auto git operations encountered errors"
  fi
}

# Run the script
main

# PList file for launchd
# #<?xml version="1.0" encoding="UTF-8"?>
# <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
# <plist version="1.0">
# <dict>
#     <key>Label</key>
#     <string>com.user.auto_git</string>
#     <key>ProgramArguments</key>
#     <array>
#         <string>/bin/bash</string>
#         <string>/usr/local/bin/auto_git.sh</string>
#     </array>
#     <key>StartInterval</key>
#     <integer>3600</integer>
#     <key>StandardOutPath</key>
#     <string>/path/to/your/logs/auto_git_launchd.log</string>
#     <key>StandardErrorPath</key>
#     <string>/path/to/your/logs/auto_git_launchd_error.log</string>
#     <key>EnvironmentVariables</key>
#     <dict>
#         <key>PATH</key>
#         <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
#     </dict>
# </dict>
# </plist>
