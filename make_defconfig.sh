#!/bin/bash
export ARCH=arm
export SUBARCH=arm
make pulshen_taoshan_defconfig
make menuconfig
make savedefconfig && cp defconfig arch/arm/configs/pulshen_taoshan_defconfig
rm defconfig
ITSME=$(git config user.name)
echo -n "Do you wan't to commit? [Y/N]: "
read douwant
case "$douwant" in
  y|Y)
if [ $ITSME == Sudokamikaze ]; then
echo "defconfig: "
read commitmsg
git add arch/arm/configs/pulshen_taoshan_defconfig
git commit -S -m "defconfig: $commitmsg"
git push
fi
;;
  n|N) exit
;;
esac
