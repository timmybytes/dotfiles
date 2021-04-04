#!/usr/bin/env bash
#===============================================================
# CLEAR CACHES
#===============================================================
# Description: A simple script to clear out caches on Mac.
# WARNING - Uses sudo — be sure you're okay with deleting!
# Author: Timothy Merritt, 2020
#===============================================================

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color, resets
PENDING="${YELLOW}●${NC}"
FAILED="${RED}𐄂${NC}"
SUCCEEDED="${GREEN}✓${NC}"

clear

d_usr() {
  sudo rm -rf /Users/$USER/Library/Caches >>/Users/$USER/logs/cache_log.txt 2>&1
  usr_status=$?
  sleep 1
  [ "$usr_status" -eq 0 ] && printf "%b\n" "${SUCCEEDED} User Cache successfully deleted" && sleep 1 || printf "%b\n" "${FAILED} There were errors. Check ~/logs/cache_log for details" && sleep 3
  # tree-list 1 level deep with human-readable filesizes
  tree -aFL 1 -s -h -C --du /Users/$USER/Library/Caches
  echo
}

d_sys() {
  sudo rm -rf /Library/Caches >>/Users/$USER/logs/cache_log.txt 2>&1
  sys_status=$?
  sleep 1
  [ "$sys_status" -eq 0 ] && printf "%b\n" "${SUCCEEDED} System Cache successfully deleted" && sleep 1 || printf "%s\b" "${FAILED} There were errors. Check ~/logs/cache_log for details" && sleep 3
  # tree-list 1 level deep with human-readable filesizes
  tree -aFL 1 -s -h -C --du /Library/Caches
  echo
}

main() {
  printf "%s\n" "// DELETE CACHES"
  printf "─%.0s" {1..46}
  echo
  printf "%s" "" "To list current system caches, enter 'sys'"
  printf "%s\n" "" "To list current user caches, enter 'usr'"
  printf "%s" "" "To delete both caches immediately, enter 'da'"
  printf "%s\n" "" "Press 'Enter' to exit"
  printf "%s" "> "
  read input
  if [ "$input" = "da" ]; then
    clear
    d_usr
    d_sys
    main
  elif [ "$input" = "sys" ]; then
    clear
    # tree-list 1 level deep with human-readable filesizes
    tree -aFL 1 -s -h -C --du /Library/Caches
    printf "%s\n" "Would you like to clear the sys cache? (y/n)"
    read sys_cache
    if [ "$sys_cache" = "y" ]; then
      clear
      d_sys
      main
    else
      clear
      main
    fi
  elif [ "$input" = "usr" ]; then
    clear
    # tree-list 1 level deep with human-readable filesizes
    tree -aFL 1 -s -h -C --du /Users/$USER/Library/Caches
    printf "%s\n" "Would you like to clear the usr cache? (y/n)"
    read usr_cache
    if [ "$usr_cache" = "y" ]; then
      clear
      d_usr
      main
    else
      clear
      main
    fi
  else
    clear
    exit 0
  fi
}
main
