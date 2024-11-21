#!/usr/bin/env bash

#title          :dice_roller.sh
#description    :Dice roller
#author         :Timothy Merritt
#date           :2024-11-18
#version        :0.1
#usage          :./dice_roller.sh
#notes          :
#bash_version   :5.2.37(1)-release
#============================================================================

# A CLI dice roller
# Usage: ./dice_roller.sh <number of dice>d <number of sides>
# Example: ./dice_roller.sh 2d6
# Also accepts multipliers and modifiers
# Example: ./dice_roller.sh 2d6*2+3

roll_dice() {
  local num_dice=$1
  local num_sides=$2
  local total=0

  for ((i = 0; i < num_dice; i++)); do
    roll=$((RANDOM % num_sides + 1))
    total=$((total + roll))
  done

  echo "$total"
}

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <number of dice>d<number of sides>[*<multiplier>][+<modifier>]"
  echo "Example: $0 2d6*2+3"
  echo "  <number of dice> - The number of dice to roll"
  echo "  <number of sides> - The number of sides on each die"
  echo "  <multiplier> - Optional. Multiplies the total roll by this number"
  echo "  <modifier> - Optional. Adds this number to the total roll"
  exit 1
fi

input=$1

num_dice=$(echo "$input" | grep -o '^[0-9]\+' | head -1)
num_sides=$(echo "$input" | grep -o 'd[0-9]\+' | cut -d'd' -f2)
multiplier=$(echo "$input" | grep -oE '\*[0-9]+' | cut -d'*' -f2)
modifier=$(echo "$input" | grep -oE '\+[0-9]+' | cut -d'+' -f2)

multiplier=${multiplier:-1}
modifier=${modifier:-0}

# Display individual rolls and calculate total
rolls=()
total=0
for ((i = 0; i < num_dice; i++)); do
  roll=$((RANDOM % num_sides + 1))
  rolls+=("$roll")
  total=$((total + roll))
done

# Apply multiplier and modifier
total=$((total * multiplier + modifier))

rolls_str=$(
  IFS=" + "
  echo "${rolls[*]}"
)

if [[ $modifier -ne 0 ]]; then
  echo "${num_dice}d${num_sides}: $total ($rolls_str) + $modifier"
else
  echo "${num_dice}d${num_sides}: $total ($rolls_str)"
fi
