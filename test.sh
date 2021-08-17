#!/usr/bin/env bash
#title          :test.sh
#description    :
#author         :
#date           :2021-08-17
#version        :
#usage          :./test.sh
#notes          :
#bash_version   :5.1.8(1)-release
#============================================================================


TERM=vscode
check_commit=$(git status | grep $TERM)

if [ "$check_commit" ]; then
  code --list-extensions > ../vscode/extensions.txt
else
  echo "false"
fi
