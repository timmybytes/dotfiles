#!/usr/bin/env bash
#===============================================================
# CLEAR CACHES
#===============================================================
# Description: A simple script to clear out caches on Mac.
# WARNING - Uses sudo — be sure you're okay with deleting!
# Author: Timothy Merritt, 2020
#===============================================================

d_usr() {
  sudo rm -rf /Users/$USER/Library/Caches >>/Users/$USER/logs/cache_log.txt 2>&1
  usr_status=$?
  sleep 1
  [ "$usr_status" -eq 0 ] && printf "%s\n" "User Cache successfully deleted" && sleep 1 && clear || printf "%s\n" "There were errors. Check ~/logs/cache_log for details"
  # tree-list 1 level deep with human-readable filesizes
  tree -shFL 1 --du /Users/$USER/Library/Caches
}

d_sys() {
  sudo rm -rf /Library/Caches >>/Users/$USER/logs/cache_log.txt 2>&1
  sys_status=$?
  sleep 1
  [ "$sys_status" -eq 0 ] && printf "%s\n" "System Cache successfully deleted" && sleep 1 && clear || printf "%s\n" "There were errors. Check ~/logs/cache_log for details"
  # tree-list 1 level deep with human-readable filesizes
  tree -shFL 1 --du /Library/Caches
}

main() {
  clear
  printf "%s" "// DELETE CACHES"
  printf "%s\n" "" "- To list current system caches, enter 'sys'"
  printf "%s" "" "- To list current user caches, enter 'usr'"
  printf "%s" "" "- To delete both caches immediately, enter 'da'"
  printf "%s\n" "" "- Press 'Enter' to exit"
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
    tree -shFL 1 --du /Library/Caches
    printf "%s\n" "Would you like to clear the sys cache? (y/n)"
    read sys_cache
    if [ "$sys_cache" = "y" ]; then
      d_sys
      main
    else
      main
    fi
  elif [ "$input" = "usr" ]; then
    clear
    # tree-list 1 level deep with human-readable filesizes
    tree -shFL 1 --du /Users/$USER/Library/Caches
    printf "%s\n" "Would you like to clear the usr cache? (y/n)"
    read usr_cache
    if [ "$usr_cache" = "y" ]; then
      d_usr
      main
    else
      main
    fi
  else
    clear
    cd
    exit 0
  fi
}
main
