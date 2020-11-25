#!/bin/bash -
#title          :check_branch.sh
#description    :Pre-push git hook
#author         :Timothy Merritt
#date           :2020-11-24
#version        :0.0.1
#usage          :./pre-push.sh
#notes          :
#bash_version   :5.0.18(1)-release
#============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

current_branch=$(git branch --show-current)

if [ "$current_branch" = "main" ]; then
  sleep 1
  printf "%s" "Heeeyy"
  sleep .5
  printf "%s" "."
  sleep .5
  printf "%s" "."
  sleep .5
  printf "%s" "."
  sleep .5
  printf "%s" "."
  sleep .5
  printf "%s" "."
  sleep .5
  printf "%s" "."
  sleep .5
  printf "%s\n" "."
  sleep 2
  echo -e "${RED}You're in production!${NC}"
  sleep 2
  printf "%s\n" "YOU'RE BETTER THAN THIS!"
  printf "%s\n"
  sleep 2
  printf "%s\n" "Seriously though, I'm not pushing this."
  sleep 2
  printf "%s\n" "Go open a pull request and think about what you've done."
  sleep 2
  exit 1
elif [ "$current_branch" = "dev" ]; then
  echo -e "${GREEN}Good job! You're in dev!"
  sleep 1
  echo -e "I will allow this.${NC}"
  sleep 2
  exit 0
fi
