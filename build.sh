 #
 # Copyright 2016, Pulshen Sudokamikaze "sudokamikaze"
 #
 # Custom build script
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 #
#!/bin/bash
DIR=$(pwd)
export CROSS_COMPILE="/home/kitt/Git/toolchains/4.8.3-2014.03.20140318.CR83/bin/arm-gnueabi-"
STRIP="/home/kitt/Git/toolchains/4.8.3-2014.03.20140318.CR83/bin/arm-gnueabi-strip"
MODULES_DIR="$DIR/modules_dir"
ZIMAGE="$DIR/arch/arm/boot/zImage"
KERNEL_DIR="$DIR"
MKBOOTIMG="$DIR/tools/mkbootimg"
MKBOOTFS="$DIR/tools/mkbootfs"
BUILD_START=$(date +"%s")
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER="Pulshen"
export KBUILD_BUILD_HOST="QUVNTNM"
DATE=$(date +%Y-%m-%d:%H:%M:%S)
if [ -a $KERNEL_DIR/arch/arm/boot/zImage ];
then
rm $ZIMAGE
rm $MODULES_DIR/*
fi
echo =============================
echo "1. Build"
echo "2. Build and log to file"
echo =============================
echo -n "Choose an action: "
read menu
case "$menu" in
  1)  echo ==============================
  echo "1. Just build"
  echo "2. Build and shutdown"
  echo ==============================
  echo -n "Choose an option: "
  read option
  if [ $option == 1 ]; then make pulshen_taoshan_defconfig; make -j5
elif [ $option == 2 ]; then pulshen_taoshan_defconfig; make -j5; poweroff
  else
    echo "Unknown symbol"
  fi
  ;;
  2)
  touch compile-debug-$DATE.log
  echo Build process output will be logged to this file >> compile-debug-$DATE.log
  echo ================================================== >> compile-debug-$DATE.log
  make pulshen_taoshan_defconfig
  make -j5 | tee -a compile-debug-$DATE.log
  echo LOG FILE ENDED >> compile-debug-$DATE.log
  ;;
  *) echo Unknown symbol
  ;;
esac
if [ -a $ZIMAGE ];
then
# echo "Copying modules"
# rm $MODULES_DIR/*
# find . -name '*.ko' -exec cp {} $MODULES_DIR/ \;
# cd $MODULES_DIR
# echo "Stripping modules for size"
# $STRIP --strip-unneeded *.ko
# zip -9 modules *
# cd $KERNEL_DIR
# echo "Creating boot image"
# $MKBOOTFS ramdisk/ > $KERNEL_DIR/ramdisk.cpio
# cat $KERNEL_DIR/ramdisk.cpio | gzip > $KERNEL_DIR/root.fs
# $MKBOOTIMG --kernel $ZIMAGE --ramdisk $KERNEL_DIR/root.fs --cmdline "console=ttyHSL0,115200,n8 androidboot.hardware=qcom androidboot.selinux=permissive user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 maxcpus=2" --base 0x80200000 --pagesize 2048 --ramdisk_offset 0x02000000 -o $KERNEL_DIR/boot.img
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
else
echo "Compilation failed! Fix the errors!"
fi
