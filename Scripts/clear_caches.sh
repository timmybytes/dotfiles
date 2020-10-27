#!/bin/bash
#===============================================================
# CLEAR CACHES
#===============================================================
# Description: A simple script to clear out caches on Mac.
# WARNING - This involves sudo, so be sure you're okay with deleting!
# Author: Timothy Merritt, 2020
#===============================================================

main () {
  clear
  printf "%s" "// DELETE CACHES"
  printf "%s\n" "" "- To list current system caches, enter 'sys'"
  printf "%s" "" "- To list current user caches, enter 'usr'"
  printf "%s\n" "" "- Press 'Enter' to exit"
  printf "%s" "> "
  read input
  if [ "$input" = "sys" ]; then
    clear
    # tree-list 1 level deep with human-readable filesizes
    tree -shFL 1 --du /Library/Caches
    printf "%s\n" "Would you like to clear the sys cache? (y/n)"
    read sys_cache
    if [ "$sys_cache" = "y" ]; then
      sudo rm -rf /Library/Caches
      clear
      sleep 1
      printf "%s" "Sytem Cache successfully deleted"
      sleep 1.5
    # tree-list 1 level deep with human-readable filesizes
      tree -shFL 1 --du /Library/Caches
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
      sudo rm -rf /Users/$USER/Library/Caches
      clear
      sleep 1
      printf "%s" "User Cache successfully deleted"
      sleep 1.5
    # tree-list 1 level deep with human-readable filesizes
      tree -shFL 1 --du /Users/$USER/Library/Caches
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
