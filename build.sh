 #
 # Copyright � 2014, Varun Chitre "varun.chitre15" <varun.chitre15@gmail.com>
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
# export CROSS_COMPILE="/root/toolchains/arm-eabi-linaro-4.6.2/bin/arm-eabi-"
# export CROSS_COMPILE="/root/cm11/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-"
export CROSS_COMPILE="/home/kitt/Git/toolchains/4.9.3-2014.12.20141230.CR83/bin/arm-eabi-"
STRIP="/home/kitt/Git/toolchains/4.9.3-2014.12.20141230.CR83/bin/arm-eabi-strip"
MODULES_DIR="/home/kitt/Git/XKernel-taoshan/modules_dir"
ZIMAGE="/home/kitt/Git/XKernel-taoshan/arch/arm/boot/zImage"
KERNEL_DIR="/home/kitt/Git/XKernel-taoshan/"
MKBOOTIMG="/home/kitt/Git/XKernel-taoshan/tools/mkbootimg"
MKBOOTFS="/home/kitt/Git/XKernel-taoshan/tools/mkbootfs"
BUILD_START=$(date +"%s")
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER="Pulshen"
export KBUILD_BUILD_HOST="QUVNTNM"
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
  echo -n "Choose an action: "
  read option
  if [ $option == 1 ]; then make pulshen_taoshan_defconfig; make -j5
elif [ $option == 2]; then pulshen_taoshan_defconfig; make -j5; poweroff
  else
    echo "Unknown symbol"
  fi
  ;;
  2)
  touch compile-debug-$DATE.log
  echo Makepkg command output will be logged to this file >> compile-debug-*.log
  echo ================================================== >> compile-debug-*.log
  make pulshen_taoshan_defconfig
  make -j5 | tee -a compile-debug-*.log
  echo LOG FILE ENDED >> compile-debug-*.log
  ;;
  *) echo Unknown symbol
  ;;
esac
# make pulshen_taoshan_defconfig
# make -j5
if [ -a $ZIMAGE ];
then
echo "Copying modules"
rm $MODULES_DIR/*
find . -name '*.ko' -exec cp {} $MODULES_DIR/ \;
cd $MODULES_DIR
echo "Stripping modules for size"
$STRIP --strip-unneeded *.ko
zip -9 modules *
cd $KERNEL_DIR
echo "Creating boot image"
$MKBOOTFS ramdisk/ > $KERNEL_DIR/ramdisk.cpio
cat $KERNEL_DIR/ramdisk.cpio | gzip > $KERNEL_DIR/root.fs
$MKBOOTIMG --kernel $ZIMAGE --ramdisk $KERNEL_DIR/root.fs --cmdline "console=ttyHSL0,115200,n8 androidboot.hardware=qcom androidboot.selinux=permissive user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 maxcpus=2" --base 0x80200000 --pagesize 2048 --ramdisk_offset 0x02000000 -o $KERNEL_DIR/boot.img
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
else
echo "Compilation failed! Fix the errors!"
fi
