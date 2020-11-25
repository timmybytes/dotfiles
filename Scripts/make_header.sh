#!/usr/bin/env bash
#title            :mkscript.sh
#description      :Make a header for a bash script open in $EDITOR
#author           :bgw
#date             :20111101
#version          :0.4
#usage            :bash mkscript.sh
#notes            :Install Vim and Emacs to use this script.
#bash_version     :4.1.5(1)-release
#==============================================================================
# Original source
# https://code.activestate.com/recipes/577862-bash-script-to-create-a-header-for-bash-scripts/

today=$(date +%Y-%m-%d)
div=======================================

/usr/bin/clear

_select_title() {

  # Get the user input.
  printf "Enter a title: "
  read -r title

  # Remove the spaces from the title if necessary.
  title=${title// /_}

  # Convert uppercase to lowercase.
  title=${title,,}

  # Add .sh to the end of the title if it is not there already.
  [ "${title: -3}" != '.sh' ] && title=${title}.sh

  # Check to see if the file exists already.
  if [ -e $title ]; then
    printf "\n%s\n%s\n\n" "The script \"$title\" already exists." \
      "Please select another title."
    _select_title
  fi

}

_select_title

printf "Enter a description: "
read -r dscrpt
printf "Enter your name: "
read -r name
printf "Enter the version number: "
read -r vnum

# Format the output and write it to a file.
printf "%-16s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%-16s%-8s\n\
%s\n\n\n" '#!/usr/bin/env bash -' '#title' ":$title" '#description' \
  ":${dscrpt}" '#author' ":$name" '#date' ":$today" '#version' \
  ":$vnum" '#usage' ":./$title" '#notes' ':' '#bash_version' \
  ":${BASH_VERSION}" \#$div${div} >$title

# Make the file executable.
chmod +x $title

# Clear screen
/usr/bin/clear

# Open with default editor on 12th line
nvim +12 $title
