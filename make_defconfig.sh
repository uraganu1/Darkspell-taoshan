#!/bin/bash
export ARCH=arm
export SUBARCH=arm
make pulshen_taoshan_defconfig
make menuconfig
make savedefconfig && cp defconfig arch/arm/configs/pulshen_taoshan_defconfig
