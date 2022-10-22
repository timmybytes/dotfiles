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
  sleep .5
  code-insiders --list-extensions >"$vs_ext_file"
}

# Main script
main() {
  printf "\e[1;33m%-4s\e[mChecking VS Code Extensions\n" "●"
  sleep .5
  # Check if file exists
  if [ -f "$vs_ext_file" ]; then
    printf "Writing extensions...\n"
    write_ext
  else
    printf "Extension file does not exist, creating new.\n"
    sleep .5
    touch "$vs_ext_file"
    write_ext
  fi
  printf "\e[0;32m%-4s\e[mFinished\n" "✔"
  exit 0
}

main
