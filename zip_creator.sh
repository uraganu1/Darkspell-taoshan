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
rm -rf XKernel-Flasher
git clone https://github.com/Sudokamikaze/XKernel-Flasher-taoshan.git && cd XKernel-Flasher-taoshan
cp ../arch/arm/boot/zImage tools/
cp ../drivers/staging/prima/firmware_bin/WCNSS_qcom_cfg.ini system/etc/firmware/wlan/prima/
eval $(grep CONFIG_LOCALVERSION= ../arch/arm/configs/pulshen_taoshan_defconfig)
echo Welcome to XKernel flash zip creator
echo =======================================
echo 1 Default flash configuration
echo 2 Tunned for battery and performance
echo 3 Extra performance
echo ========================================
echo Current kernel version : $CONFIG_LOCALVERSION
echo -n "Choose an action: "
read item
case "$item" in
  1) echo "Creating default flash zip"
  cp scripts/updater-script-default META-INF/com/google/android/
  mv META-INF/com/google/android/updater-script-default META-INF/com/google/android/updater-script
  ;;
  2) echo "Creating tunned zip"
  cp scripts/updater-script-balanced META-INF/com/google/android/
  mv META-INF/com/google/android/updater-script-balanced META-INF/com/google/android/updater-script
  ;;
  3) echo "Creating zip with configured to extra performance"
  cp scripts/updater-script-performance META-INF/com/google/android/
  mv META-INF/com/google/android/updater-script-performance META-INF/com/google/android/updater-script
  ;;
  *) echo "Waiting for input"
  ;;
esac
zip XKernel-Stable.zip -r META-INF presets system tools
mv XKernel-Stable.zip signer/
echo Signing zip file
cd signer && java -jar signapk.jar testkey.x509.pem testkey.pk8 XKernel-Stable.zip XKernel-Stable-signed.zip
echo Done!
echo You may grab your zip file in XKernel-Flasher-taoshan directory
rm XKernel-Stable.zip
mv XKernel-Stable-signed.zip ../
