#!/usr/bin/env bash
#title          :check-extensions.sh
#description    :List VS Code extensions to file, overwrite if contents is changed
#author         :Timothy Merritt
#date           :2022-10-18
#version        :0.0.1
#usage          :./check-extensions.sh
#notes          :
#bash_version   :5.2.2(1)-release
#============================================================================

# VS Code extension file
vs_ext_file=$HOME/.dotfiles/vscode/extensions.txt

# List VS Code extensions and write to file
write_ext() {
  printf "Writing extensions to %s\n" "$vs_ext_file"
  code-insiders --list-extensions >"$vs_ext_file"
}

# Main script
main() {
  printf "%s\n%s\n\n" "List & Write VS Code Extensions" "-------------------------------"
  # Check if file exists
  if [ -f "$vs_ext_file" ]; then
    printf "%s exists!\n" "$vs_ext_file"
    # Check if file is not empty
    if [ -s "$vs_ext_file" ]; then
      write_ext
    else
      printf "%s is empty.\n" "$vs_ext_file"
      write_ext
    fi
    printf "Checking write process\n"

  else
    printf "%s does not exist. Creating extension file.\n" "$vs_ext_file"
    touch "$vs_ext_file"
    write_ext
  fi
  printf "Finished.\n"
}

main
