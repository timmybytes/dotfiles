#!/usr/bin/env bash
#title          :add_prefix.sh
#description    :Adds a prefix to each line of a file
#author         :Timothy Merritt
#date           :2023-10-21
#version        :0.1.0
#usage          :./add_prefix.sh
#notes          :
#bash_version   :5.2.15(1)-release
#============================================================================

# Help function
help() {
  echo "Usage: $0 [-h] [-p prefix] [-n] [-o output] input"
  echo "  -h: Print this help message"
  echo "  -p: Prefix to add to each line (default is empty)"
  echo "  -n: Include sequential numbering as prefix"
  echo "  -o: Output file (default is stdout)"
  echo "  input: Input file to add prefix to"
}

# Initialize variables
prefix=""
numbering=false
output=""
input=""

# Parse options
while getopts "hp:no:" opt; do
  case $opt in
  h)
    help
    exit 0
    ;;
  p)
    prefix="$OPTARG"
    ;;
  n)
    numbering=true
    ;;
  o)
    output="$OPTARG"
    ;;
  \?)
    echo "Invalid option: -$OPTARG"
    exit 1
    ;;
  :)
    echo "Option -$OPTARG requires an argument."
    exit 1
    ;;
  esac
done

# Shift to get the remaining arguments
shift $((OPTIND - 1))

# Check for input file
if [ -z "$1" ]; then
  echo "Input file is required. Use -h for help."
  exit 1
fi

input="$1"

# Validate input file
if [ ! -f "$input" ]; then
  echo "Input file not found!"
  exit 1
fi

# Function to count lines in a file
count_lines() {
  wc -l "$1" | awk '{ print $1 }'
}

# Function to process lines
process_lines() {
  lineno=1
  total_lines=$(count_lines "$input")
  padding_length=$((${#total_lines} + 1))

  while read -r line; do
    output_line="$prefix"
    [ "$numbering" = true ] && output_line="${output_line}$(printf "%0${padding_length}d " $lineno)"
    output_line="${output_line}${line}"
    echo "$output_line"
    lineno=$((lineno + 1))
  done <"$input"
}

# Handle output
if [ -z "$output" ]; then
  process_lines
else
  process_lines >"$output"
fi
