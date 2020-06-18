#!/bin/bash
#
# Commit Central Script for LH Kernel
#
# Copyright (C) 2020 Luan Halaiko and LuizPauloDamaceno (tecnotailsplays@gmail.com) (luizpaulodamaceno@live.com)
#
# Private release DO NOT DISTRIBUTE, all files including this one are made by Luan Halaiko to compile
# the builds of LH Kernel in his workspace, it will not come along on any source by any means.

#Colors
black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
brown='\033[0;33m'
blue='\033[0;34m'
purple='\033[1;35m'
cyan='\033[0;36m'
nc='\033[0m'

#LH Logo
echo -e "$blue############################ LH COMMIT CENTRAL #############################$nc"
#Main script
while true; do
echo -e "\n$green[1]Cherry-pick"
echo -e "[2]Revert"
echo -e "[3]Quit$nc"
echo -ne "\n$brown(i)Enter a choice[1-5]:$nc "

read choice

if [ "$choice" == "1" ]; then
 while true
 do
        echo "Cherry-pick: "
        read REVERT
        git cherry-pick $REVERT
        echo "DONE"
 done
fi

if [ "$choice" == "2" ]; then
 while true
 do
        echo "Revert: "
        read REVERT
        git revert $REVERT
        echo "DONE"
 done
fi

if [ "$choice" == "3" ]; then
 exit 1
fi
done
