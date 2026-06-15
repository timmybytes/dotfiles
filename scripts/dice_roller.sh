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
# Usage: ./dice_roller.sh <number of dice>d<number of sides>
# Example: ./dice_roller.sh 2d6
# Also accepts multipliers and modifiers
# Example: ./dice_roller.sh 2d6*2+3
# If only a die is provided, defaults to 1 die
# Example: ./dice_roller.sh d20

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <number of dice>d<number of sides>[*<multiplier>][+<modifier>]"
  echo "Example: $0 2d6*2+3"
  echo "Example: $0 d20"
  echo "  <number of dice> - The number of dice to roll (defaults to 1 if omitted)"
  echo "  <number of sides> - The number of sides on each die"
  echo "  <multiplier> - Optional. Multiplies the total roll by this number"
  echo "  <modifier> - Optional. Adds this number to the total roll"
  exit 1
fi

input=$1

if [[ ! $input =~ ^([0-9]*)d([0-9]+)(\*([0-9]+))?(\+([0-9]+))?$ ]]; then
  echo "Invalid input: $input"
  echo "Usage: $0 <number of dice>d<number of sides>[*<multiplier>][+<modifier>]"
  echo "Example: $0 2d6*2+3"
  echo "Example: $0 d20"
  exit 1
fi

num_dice=${BASH_REMATCH[1]}
num_sides=${BASH_REMATCH[2]}
multiplier=${BASH_REMATCH[4]}
modifier=${BASH_REMATCH[6]}

num_dice=${num_dice:-1}
multiplier=${multiplier:-1}
modifier=${modifier:-0}

rolls=()
subtotal=0

for ((i = 0; i < num_dice; i++)); do
  roll=$((RANDOM % num_sides + 1))
  rolls+=("$roll")
  subtotal=$((subtotal + roll))
done

total=$((subtotal * multiplier + modifier))

rolls_str=$(
  IFS=" + "
  echo "${rolls[*]}"
)

output="${num_dice}d${num_sides}: $total ($rolls_str)"

if [[ $multiplier -ne 1 ]]; then
  output+=" * $multiplier"
fi

if [[ $modifier -ne 0 ]]; then
  output+=" + $modifier"
fi

echo "$output"
