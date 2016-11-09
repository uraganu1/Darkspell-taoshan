#
# Copyright � 2016, Pulshen Sudokamikaze "sudokamikaze" sudokamikaze.github.io
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
rm -rf Darkspell-Flasher-taoshan
git clone https://github.com/Sudokamikaze/Darkspell-Flasher-taoshan.git && cd Darkspell-Flasher-taoshan
cp ../arch/arm/boot/zImage tools/
cp ../drivers/staging/prima/firmware_bin/WCNSS_qcom_cfg.ini system/etc/firmware/wlan/prima/
eval $(grep CONFIG_LOCALVERSION= ../arch/arm/configs/pulshen_taoshan_defconfig)
DATE=$(date +%d-%m-%Y)
zip Darkspell-Stable.zip -r META-INF presets system tools
mv Darkspell-Stable.zip signer/
echo Signing zip file
cd signer && java -jar signapk.jar testkey.x509.pem testkey.pk8 Darkspell-Stable.zip Darkspell-Stable-signed.zip
echo Done!
echo You may grab your zip file in Darkspell-Flasher-taoshan directory
rm Darkspell-Stable.zip
mv Darkspell-Stable-signed.zip ../Taoshan-MM$CONFIG_LOCALVERSION-$DATE.zip
cd ..
echo -n "Do you wan't to push zip to sdcard? [Y/N]: "
read push
case "$push" in
  y|Y) adb shell mkdir /storage/E53B-ACF6/Darkspell
  adb push Taoshan-LP$CONFIG_LOCALVERSION-*.zip /storage/E53B-ACF6/Darkspell/
  ;;
  n|N) echo You may grab your zip file in Darkspell-Flasher-taoshan directory
  ;;
esac
