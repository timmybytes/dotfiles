#!/usr/bin/env bash
#title          :nodeswitch.sh
#description    :Display verbose information when switching node versions with nvm
#author         :Timothy Merritt
#date           :2024-11-07
#version        :0.1
#usage          :./nodeswitch.sh
#notes          :
#bash_version   :5.2.37(1)-release
#============================================================================

# Load nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Current Node Version
CURRENT_NODE_VERSION=$(node -v)

# If 'nvm use' results in a different version, grep the version number
# from the output and assign it to the variable NEW_NODE_VERSION
NEW_NODE_VERSION=$(nvm use | grep -o 'Now using node v[0-9]\+\.[0-9]\+\.[0-9]\+' | awk '{print $4}')

# Create a main function to run the script that approximates 'nvm use' with the above verbose information included in the output
main() {
  if [ "$CURRENT_NODE_VERSION" != "$NEW_NODE_VERSION" ]; then
    echo -e "🔄 Switching from Node.js version \033[1;33m$CURRENT_NODE_VERSION\033[0m to \033[1;32m$NEW_NODE_VERSION\033[0m"
    nvm use
  else
    echo -e "✅ Node.js version \033[1;32m$CURRENT_NODE_VERSION\033[0m is already in use"
  fi
}

# Run the main function
main
