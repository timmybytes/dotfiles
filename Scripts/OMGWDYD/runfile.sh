#! /usr/bin/env bash
clear
# Current parent directory only
dirs=${PWD##*/}

# Yesterday's date - Uses 'gdate' from GNU coreutils - NOT NEEDED
# yesterday=${gdate --date="yesterday" +"%Y-%m-%d 00:00"}

printf '=%.0s' {1..40}
echo
printf '%s\n' "LOOK AT WHAT YOU DID"

# For each directory in #Repos
for dir in /Users/nym/Projects/\#Repos/* ; do
  # 1. ADD - If dir is a directory, cd into it
  cd "$dir" 2>/dev/null
  # 2. ADD - If directory contains .git directory, continue; else, next loop
  # iteration
  if [ -d .git ]; then
    # 3. Print name of current directory removed from full filepath
    # echo $dirs
    # 4. Print git log since yesterday
    # git --no-pager log --oneline --since="yesterday"
    if [[ $(git log --pretty=format:'%h was %an, %ar, message: %s' --since="yesterday") ]]; then
      printf '=%.0s' {1..40}
      echo
      printf "Repository: "
      printf '%s\n' "${PWD##*/}"
      printf '=%.0s' {1..40}
      echo
      git --no-pager log --since="yesterday" --pretty=tformat:"%x20%x20%s"
    else
      continue
    fi
    # 5. cd back to #Repos
  else
    cd ..
    continue
  fi
  cd ..
done
