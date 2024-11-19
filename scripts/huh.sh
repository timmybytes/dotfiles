# Shell script that takes a command-line command and simply describes what it does without running it.
#
# Usage: ./huh.sh <command>
# Example: ./huh.sh "ls -l"
# Output: List files in long format
#
# This script is useful for understanding what a command does before running it.
# It does not execute the command, only describes its functionality.

# Display help message
help_message() {
  echo "Usage: ./huh.sh <command>"
  echo "Example: ./huh.sh \"ls -l\""
  echo "Output: List files in long format"
  echo
  echo "This script is useful for understanding what a command does before running it."
  echo "It does not execute the command, only describes its functionality."
}

# Check for a valid command input
if [[ -z "$1" ]] || [[ "$1" == "-h" || "$1" == "--help" ]]; then
  help_message
  exit 0
fi

# Extract the command description
command_description=$(whatis "$1")

# Display the command description
echo "Command: $1"
echo "Description: $command_description"
