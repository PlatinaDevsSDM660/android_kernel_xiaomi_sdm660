#!/bin/bash
#
# LH Kernel Next Gen Build Script
#
# Copyright (C) 2020 Luan Halaiko (tecnotailsplays@gmail.com)
#
# Private release DO NOT DISTRIBUTE, all files including this one are made by Luan Halaiko to compile
# the builds of LH Kernel in his workspace, it will not come along on any source by any means.
#
#Colors
black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
brown='\033[0;33m'
blue='\033[0;34m'
purple='\033[1;35m'
cyan='\033[0;36m'
nc='\033[0m'

#Directories
KERNEL_DIR=$PWD
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
ZIP_DIR=$KERNEL_DIR/Zip-out
CONFIG_DIR=$KERNEL_DIR/arch/arm64/configs

#Export
export CROSS_COMPILE="$HOME/workfolder/toolchain/GOOGLE-4.9/bin/aarch64-linux-androidkernel-"
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="LuanHalaiko"
export KBUILD_BUILD_HOST="CrossBuilder"
export CLANG_PATH=~/workfolder/toolchain/CLANG-11/bin/clang
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export KBUILD_COMPILER_STRING=$(<~/workfolder/toolchain/CLANG-11/bin/clang | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')

#Out folder
mkdir -p out
THREAD="O=out -j$(grep -c ^processor /proc/cpuinfo)"
OUT="O=out"

#Defconfig
CONFIG=platina_defconfig

#LH Logo
echo -e "$blue############################ WELCOME TO #############################"
echo -e "                 __                   __  __      __  __  __           "
echo -e "                / /   /\  /\   /\ /\ /__\/__\  /\ \ \/__\/ /           "
echo -e "               / /   / /_/ /  / //_//_\ / \// /  \/ /_\ / /            "
echo -e "              / /___/ __  /  / __ \//__/ _  \/ /\  //__/ /___          "
echo -e "              \____/\/ /_/   \/  \/\__/\/ \_/\_\ \/\__/\____/          "
echo -e "                                                                       "
echo -e "\n############################# BUILDER ###############################$nc"

#Main script
while true; do
echo -e "\n$green[1]Build Kernel CLANG"
echo -e "[2]Build Kernel GCC"
echo -e "[3]Update Defconfig"
echo -e "[4]Source Cleanup"
echo -e "[5]Create Flashable zip"
echo -ne "\n$brown(i)Enter a Choice[1-5]:$nc "

read choice

if [ "$choice" == "1" ]; then
  BUILD_START=$(date +"%s")
  DATE=`date`
  echo -e "\n$cyan#######################################################################$nc"
  echo -e "$purple(i)CLANG build has been started at $DATE$nc"
  make CC=~/workfolder/toolchain/CLANG-11/bin/clang $CONFIG $THREAD &>/dev/null
  make CC=~/workfolder/toolchain/CLANG-11/bin/clang $THREAD &>Buildlog-CLANG.txt & pid=$!
  spin[0]="$blue-"
  spin[1]="\\"
  spin[2]="|"
  spin[3]="/$nc"

  echo -ne "$blue[Please wait...] ${spin[0]}$nc"
  while kill -0 $pid &>/dev/null
  do
    for i in "${spin[@]}"
    do
          echo -ne "\b$i"
          sleep 0.1
    done
  done
  if ! [ -a $KERN_IMG ]; then
    echo -e "\n$red(!)Kernel compilation failed, check Buildlog to fix errors $nc"
    echo -e "$red#######################################################################$nc"
    exit 1
  fi
  $DTBTOOL -2 -o $KERNEL_DIR/arch/arm/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/ &>/dev/null &>/dev/null
  BUILD_END=$(date +"%s")
  DIFF=$(($BUILD_END - $BUILD_START))
  echo -e "\n$brown(i)Image-dtb compiled successfully.$nc"
  echo -e "$cyan#######################################################################$nc"
  echo -e "$purple(i)Total time elapsed: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nc"
  echo -e "$cyan#######################################################################$nc"
fi

if [ "$choice" == "2" ]; then
  BUILD_START=$(date +"%s")
  DATE=`date`
  echo -e "\n$cyan#######################################################################$nc"
  echo -e "$purple(i)GCC build has been started at $DATE$nc"
  make $CONFIG $THREAD &>/dev/null
  make $THREAD &>Buildlog-GCC.txt & pid=$!
  spin[0]="$blue-"
  spin[1]="\\"
  spin[2]="|"
  spin[3]="/$nc"

  echo -ne "$blue[Please wait...] ${spin[0]}$nc"
  while kill -0 $pid &>/dev/null
  do
    for i in "${spin[@]}"
    do
          echo -ne "\b$i"
          sleep 0.1
    done
  done
  if ! [ -a $KERN_IMG ]; then
    echo -e "\n$red(!)Kernel compilation failed, check Buildlog to fix errors $nc"
    echo -e "$red#######################################################################$nc"
    exit 1
  fi
  $DTBTOOL -2 -o $KERNEL_DIR/arch/arm/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/ &>/dev/null &>/dev/null
  BUILD_END=$(date +"%s")
  DIFF=$(($BUILD_END - $BUILD_START))
  echo -e "\n$brown(i)Image-dtb compiled successfully.$nc"
  echo -e "$cyan#######################################################################$nc"
  echo -e "$purple(i)Total time elapsed: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nc"
  echo -e "$cyan#######################################################################$nc"
fi

if [ "$choice" == "3" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  make $CONFIG
  cp .config arch/arm64/configs/$CONFIG
  echo -e "$purple(i)Defconfig updated.$nc"
  echo -e "$cyan#######################################################################$nc"
fi

if [ "$choice" == "4" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  rm -f $DT_IMG
  make clean &>/dev/null
  make mrproper &>/dev/null
  echo -e "$purple(i)Kernel source cleaned up.$nc"
  echo -e "$cyan#######################################################################$nc"
fi


if [ "$choice" == "5" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  cd $ZIP_DIR
  make clean &>/dev/null
  cp $KERN_IMG $ZIP_DIR
  make &>/dev/null
  make sign &>/dev/null
  cd ..
  echo -e "$purple(i)Flashable zip generated under $ZIP_DIR.$nc"
  echo -e "$cyan#######################################################################$nc"
fi
done
