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
rm -rf XKernel-Flasher-taoshan
git clone https://github.com/Sudokamikaze/XKernel-Flasher-taoshan.git && cd XKernel-Flasher-taoshan
cp ../arch/arm/boot/zImage tools/
cp ../drivers/staging/prima/firmware_bin/WCNSS_qcom_cfg.ini system/etc/firmware/wlan/prima/
eval $(grep CONFIG_LOCALVERSION= ../arch/arm/configs/pulshen_taoshan_defconfig)
DATE=$(date +%d-%m-%Y)
echo Welcome to XKernel flash zip creator
echo =================================================
echo "Default preset have: "
echo "zSwap = 10%"
echo "Zen I/O sched"
echo "Undervolted GPU"
echo "Normal thermald configuration"
echo ==================================================
echo "U may tune kernel perfs by using Kernel Adiutor"
echo ==================================================
zip XKernel-Stable.zip -r META-INF presets system tools
mv XKernel-Stable.zip signer/
echo Signing zip file
cd signer && java -jar signapk.jar testkey.x509.pem testkey.pk8 XKernel-Stable.zip XKernel-Stable-signed.zip
echo Done!
echo You may grab your zip file in XKernel-Flasher-taoshan directory
rm XKernel-Stable.zip
mv XKernel-Stable-signed.zip ../Taoshan-LP$CONFIG_LOCALVERSION-$DATE.zip
