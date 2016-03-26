#!/bin/bash
rm -rf XKernel-Flasher
git clone https://github.com/Sudokamikaze/XKernel-Flasher.git && cd XKernel-Flasher
cp ../arch/arm/boot/zImage tools/
cp ../drivers/staging/prima/firmware_bin/WCNSS_qcom_cfg.ini system/etc/firmware/wlan/prima/
echo Welcome to XKernel flash zip creator
echo =======================================
echo 1 Default flash configuration
echo 2 Tunned for battery and performance
echo 3 Extra performance
echo ========================================
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
zip XKernel-Rolling.zip -r META-INF presets system tools
mv XKernel-Rolling.zip signer/
echo Signing zip file
cd signer && java -jar signapk.jar testkey.x509.pem testkey.pk8 XKernel-Rolling.zip XKernel-Rolling-signed.zip
echo Done!
echo You may grab your zip file in XKernel-Flasher directory
rm XKernel-Rolling.zip
mv XKernel-Rolling-signed.zip ../
