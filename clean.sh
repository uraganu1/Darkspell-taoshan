KERNEL_DIR="/home/pulshen/Git/thunderzap_xl/"
make ARCH=arm CROSS_COMPILE="/home/pulshen/Git/toolchain/4.8.3-2013.11.20131205/bin/arm-linux-gnueabihf-" -j5 clean mrproper
rm -rf $KERNEL_DIR/ramdisk.cpio
rm -rf $KERNEL_DIR/root.fs
rm -rf $KERNEL_DIR/boot.img
