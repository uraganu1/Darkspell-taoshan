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
export CROSS_COMPILE="$HOME/Git/toolchains/architoolchain-4.8-a15/bin/arm-eabi-"
STRIP="$HOME/Git/toolchains/architoolchain-4.8-a15/bin/arm-eabi-strip"
MODULES_DIR="$DIR/modules_dir"
ZIMAGE="$DIR/arch/arm/boot/zImage"
KERNEL_DIR="$DIR"
MKBOOTIMG="$DIR/tools/mkbootimg"
MKBOOTFS="$DIR/tools/mkbootfs"
BUILD_START=$(date +"%s")
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER="Sudokamikaze"
export KBUILD_BUILD_HOST="QUVNTNM"
DATE=$(date +%Y-%m-%d:%H:%M:%S)
if [ -a $KERNEL_DIR/arch/arm/boot/zImage ];
then
rm $ZIMAGE
rm $MODULES_DIR/*
fi
make pulshen_taoshan_defconfig
make -j5
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
