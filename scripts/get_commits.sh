#!/usr/bin/env bash
#title          :get_commits.sh
#description    :Get commits for a given date range in a specified repo
#author         :Timothy Merritt
#date           :2024-04-23
#version        :0.1
#usage          :./get_commits.sh
#notes          :
#bash_version   :5.2.26(1)-release
#============================================================================

# WIP: This script is a work in progress and is not yet fully functional.

# Default values
start_date=$(date "+%Y-%m-%d")
end_date=$(date "+%Y-%m-%d")
search_dir=~/Work

# Function to show help
show_help() {
  echo "Usage: git-commits.sh [-s start_date] [-e end_date] [-d search_dir]"
  echo "  -s  Start date in YYYY-MM-DD format (default is 2 weeks ago)"
  echo "  -e  End date in YYYY-MM-DD format (default is today)"
  echo "  -d  Directory to search for Git repositories (default is ~/Projects)"
}

# # Validate date format
# validate_date() {
#   if ! date -d "$1" "+%Y-%m-%d" &>/dev/null; then
#     echo "Error: Date format is invalid. Please use YYYY-MM-DD."
#     exit 1
#   fi
# }

# Parse command-line options
while getopts 'hs:e:d:' flag; do
  case "${flag}" in
  s)
    # validate_date "${OPTARG}"
    start_date="${OPTARG}"
    ;;
  e)
    # validate_date "${OPTARG}"
    end_date="${OPTARG}"
    ;;
  d) search_dir="${OPTARG}" ;;
  h)
    show_help
    exit 0
    ;;
  *)
    show_help
    exit 1
    ;;
  esac
done

# Check if the search directory exists
if [ ! -d "$search_dir" ]; then
  echo "Error: The directory '$search_dir' does not exist."
  exit 1
fi

# Find all git repositories and iterate over them
find "$search_dir" -type d -name .git | while read -r gitdir; do
  # If dirs are in $serach_dir/Archive, skip them
  if [[ $gitdir == *Archive* ]]; then
    continue
  fi

  # Go to the repository directory
  repo_dir=$(dirname "$gitdir")
  echo "Repository: $repo_dir"
  cd "$repo_dir" || exit

  # Put the resulting commits into a temporary file, then print them from the file

  # Use git log to filter commits by date range
  git log --since="$start_date" --until="$end_date" --author="Timothy Merritt" --author="timmybytes" --format="%h - %an, %ad : %s" >commits.txt
  cat commits.txt

  # Go back to the original directory
  cd - || exit

done
