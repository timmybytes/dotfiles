#!/bin/bash -   
#title          :tweet.sh
#description    :Send a tweet from the command line
#author         :Timothy Merritt
#date           :2020-11-16
#version        :1.0.0  
#usage          :./tweet.sh
#notes          :       
#bash_version   :5.0.18(1)-release
#============================================================================

get_info () {
  read -p "Enter Twitter username: " USER
  read -p "Enter Twitter password: " PASS
  read -p "Enter status message: " MESSAGE
}

get_info

if [ $MESSAGE ]; then
  echo "$USER" " : " "$PASS"
  echo "$MESSAGE"
  read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
else
  get_info
fi

# Test

# curl -u "$USER":"$PASS" -d status="$MESSAGE" http://twitter.com/statuses/update.xml
