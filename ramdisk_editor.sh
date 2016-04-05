#
# Copyright � 2016, Pulshen Sudokamikaze "sudokamikaze" sudokamikaze.github.io
#
# Custom script for editing ramdisk settings
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
cd ramdisk
echo "Do you want to backup original files? [Y/N]: "
read backup
case "$backup" in
  y|Y) echo "Stating backup process"
  tar -cf backup_ramdisk.tar sbin/ 
  ;;
  n|N)
  ;;
esac
echo ==================================================
echo 1 Unpack ramdisk and ramdisk-recovery
echo 2 Pack newly edited ramdisk and ramdisk-recovery
echo 3 Install new ramdisk
echo ==================================================
echo -n "Choose an action: "
read item
case "$item" in
  1) echo "Unpacking ramdisk.cpio and ramdisk-recovery.cpio"
  mkdir ../ramdisk_editor
  cp ramdisk.cpio ../ramdisk_editor
  cp ramdisk-recovery.cpio ../ramdisk_editor && cd ../ramdisk-editor
  mkdir ramdisk_cpio && mv ramdisk.cpio ramdisk_cpio/ && cat ramdisk.cpio | cpio -idmv && rm ramdisk_cpio/ramdisk.cpio
  mkdir ramdisk-recovery_cpio && mv ramdisk-recovery.cpio ramdisk-recovery_cpio/ && cat ramdisk-recovery.cpio | cpio -idmv && rm ramdisk-recovery_cpio/ramdisk-recovery.cpio
  echo "Done! Your ramdisk unpacked, check ramdisk-editor dir"
  ;;
  2) echo "Preparing to pack new ramdisk"
  cd ../ramdisk_editor
  cd ramdisk_cpio && find . | cpio -o -H newc > ../ramdisk-new.cpio
  cd ramdisk-recovery_cpio && find . | cpio -o -H newc > ../ramdisk-recovery-new.cpio
  echo "Done! Your ramdisk packed, check ramdisk-editor dir"
  ;;
  3) echo "Installing new ramdisk"
  cd ../ramdisk_editor
  cp ramdisk-new.cpio ramdisk/sbin/ramdisk.cpio
  cp ramdisk-recovery-new.cpio ramdisk/sbin/ramdisk-recovery.cpio
  echo Done!
  ;;
esac
