#! /usr/bin/env bash
# ------------------------------------------------------------------
# OH MY GOD, WHAT DID YOU DO?!
# ------------------------------------------------------------------
# title          :what_you_did.sh
# description    :Checks previous day's git commits
# author         :Timothy Merritt
# date           :2020-11-12
# version        :0.0.1
# usage          :./what_you_did.sh
# notes          :chmod +x runfile.sh to make executable
# bash_version   :5.0.18(1)-release
# ------------------------------------------------------------------

# Clear screen
clear

# Header
printf -- '-%.0s' {1..65}
echo
printf '%s' "| LOOK AT WHAT YOU DID YESTERDAY"
printf -- ' %.0s' {1..32}
printf '%s\n' "|"

# For each directory in #Repos
# ---> Change this line to the parent folder of your repos <---
for dir in ~/Projects/\#Repos/* ; do
  # If dir is a directory, cd into it and silence errors (for non-directories)
  cd "$dir" 2>/dev/null
  # If directory is git repo, continue; else, next loop iteration
  if [ -d .git ]; then
    # If repo has commits since yesterday, continue; else, next loop iteration
    if [[ $(git log --pretty=format:'%h was %an, %ar, message: %s' --since="yesterday") ]]; then
      printf -- '-%.0s' {1..65}
      echo
      printf "// Repository: "
      # Print name of current directory removed from full filepath
      printf '%s\n' "${PWD##*/}"
      printf -- '-%.0s' {1..65}
      echo
      # Print git log since yesterday, show only commits
      git --no-pager log --since="yesterday" --pretty=tformat:"%x20*%x20%x20%s"
    else
      continue
    fi
  else
    # cd back to #Repos
    cd ..
    continue
  fi
  cd ..
done
