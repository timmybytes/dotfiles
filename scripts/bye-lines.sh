#!/usr/bin/env bash
#==============================================================================
# title            : bye-lines.sh
# description      : This script provides various text processing options.
# author           : Timothy Merritt
# date             : 2024-11-02
# version          : 0.2
# usage            : bash bye-lines.sh [file]
# bash_version     : 5.2
#==============================================================================

LOGO="
 _                  _ _
| |__  _   _  ___  | (_)_ __   ___  ___
| '_ \| | | |/ _ \ | | | '_ \ / _ \/ __|
| |_) | |_| |  __/ | | | | | |  __/\__ \\
|_.__/ \__, |\___| |_|_|_| |_|\___||___/
       |___/
      v.2

    Let's clean this up, shall we?
"

#==============================================================================
# Core Functionality
#==============================================================================

# Display help message
help_message() {
  echo "$LOGO"
  echo "Usage: bye-lines.sh [file]"
  echo "Provides various text processing options for a given file."
  echo
  echo "Options:"
  echo "  -h, --help    Display this help message."
  echo
  echo "Examples:"
  echo "  bye-lines.sh file.txt"
}

# Check for a valid file input
if [[ -z "$1" ]] || [[ "$1" == "-h" || "$1" == "--help" ]]; then
  help_message
  exit 0
elif [[ ! -f "$1" ]]; then
  echo "Error: File '$1' does not exist."
  exit 1
fi

# Create a temporary file to store results
temp_file=$(mktemp)

#==============================================================================
# Text Processing Functions
#==============================================================================

# Add empty lines to a file
add_empty_lines() {
  sed 'G' "$1" >"$temp_file"
}

# Remove empty lines from a file
remove_empty_lines() {
  sed '/^[[:space:]]*$/d' "$1" >"$temp_file"
}

# Remove leading whitespace from each line
remove_leading_whitespace() {
  sed 's/^[[:space:]]*//' "$1" >"$temp_file"
}

# Remove trailing whitespace from each line
remove_trailing_whitespace() {
  sed 's/[[:space:]]*$//' "$1" >"$temp_file"
}

# Convert tabs to spaces
convert_tabs_to_spaces() {
  sed 's/\t/    /g' "$1" >"$temp_file"
}

# Convert spaces to tabs
convert_spaces_to_tabs() {
  sed 's/    /\t/g' "$1" >"$temp_file"
}

#==============================================================================
# User Interaction
#==============================================================================

# Display the logo and prompt for options
echo "$LOGO"
echo "File: $1"
echo "Choose an option:"
options=("Remove empty lines" "Add empty lines" "Remove leading whitespace"
  "Remove trailing whitespace" "Convert tabs to spaces" "Convert spaces to tabs" "Exit")

select _ in "${options[@]}"; do
  case $REPLY in
  1) remove_empty_lines "$1" ;;
  2) add_empty_lines "$1" ;;
  3) remove_leading_whitespace "$1" ;;
  4) remove_trailing_whitespace "$1" ;;
  5) convert_tabs_to_spaces "$1" ;;
  6) convert_spaces_to_tabs "$1" ;;
  7)
    echo "Exiting. No changes made."
    exit 0
    ;;
  *)
    echo "Invalid option. Please try again."
    continue
    ;;
  esac
  break
done

# Show the changes before confirmation
echo "Changes preview:"
diff -u "$1" "$temp_file" || echo "No changes detected."

# Confirm overwrite
read -p "Would you like to overwrite the original file with these changes? (y/n): " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  mv "$temp_file" "$1"
  echo "Changes applied to '$1'"
else
  echo "No changes were applied to '$1'"
  rm "$temp_file"
fi
