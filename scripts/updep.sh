#!/usr/bin/env bash
#title          :updep.sh
#description    :Update dependencies
#author         :Timothy Merritt
#date           :2021-11-21
#version        :0.0.1
#usage          :./updep.sh
#notes          :
#bash_version   :3.2.57(1)-release
#============================================================================
#!/bin/zsh

PKG=package.json

for DIR in */;
do
  cd "$DIR" || return
  if test -f "$PKG"; then
    echo "Found $PKG"
    npm audit fix --force
  fi
  cd ..
done
