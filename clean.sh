DIR=$(pwd)
KERNEL_DIR="$DIR"
make ARCH=arm CROSS_COMPILE="$HOME/Git/toolchains/4.8.3-2013.11.20131205/bin/arm-linux-gnueabihf-" -j5 clean mrproper
rm -rf $KERNEL_DIR/ramdisk.cpio
rm -rf $KERNEL_DIR/root.fs
rm -rf $KERNEL_DIR/boot.img
rm -rf XKernel-Flasher-taoshan
rm -rf ramdisk_editor
