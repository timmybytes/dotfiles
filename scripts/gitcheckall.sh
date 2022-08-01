#!/usr/bin/env bash
#title          :gitcheckall.sh
#description    :Check all local repo locations for status
#author         :Timothy Merritt
#date           :2021-03-08
#version        :0.1.0
#usage          :./gitcheckall.sh
#notes          :
#bash_version   :5.1.4(1)-release
#============================================================================

# Current WIP running only the most superficial of checks with mgitstatus
clear
echo "Checking repos..."
cd ~ || return
mgitstatus -d 2
cd ~/Work || return
mgitstatus -d 2
cd ~/Projects/Repos || return
mgitstatus -d 2
