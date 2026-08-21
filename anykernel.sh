### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

# =====================================================================
# Kernel: Entropy Kernel for OPPO SM8250 (kona)
# Devices: Find X3 / Reno5 Pro+ / Reno6 Pro+
# Maintainer: bcggxx
# Source: https://github.com/bcggxx/android_kernel_oppo_sm8250
# License: GPL v2 (free and open source)
# =====================================================================

### AnyKernel setup
# global properties
properties() { '
kernel.string=Entropy Kernel by bcggxx @ OPPO SM8250

# Device check disabled: OPPO kona devices report many different
# device names (fussi, PECM30, RMX3xxx, PDxx00 ...) across regions
# and ROMs. Set to 1 and fill device.name1..5 to enforce a check.
do.devicecheck=0

# All drivers are built-in (no modules in kona-perf_defconfig)
do.modules=0

do.systemless=0
do.cleanup=1
do.cleanuponabort=1
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
# OPPO SM8250 devices are A/B slot devices with a boot partition and
# a separate dtbo partition; block is auto-detected.
BLOCK=auto;
IS_SLOT_DEVICE=1;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

ui_print " ";
ui_print "**********************************************";
ui_print " OPPO SM8250 (kona) 专用内核";
ui_print " Entropy Kernel for OPPO SM8250";
ui_print "**********************************************";
ui_print " 维护者 / Maintainer: bcggxx";
ui_print "**********************************************";
ui_print " 源码 / Source:";
ui_print " https://github.com/bcggxx/android_kernel_oppo_sm8250";
ui_print "**********************************************";
ui_print " 本内核免费且开源，遵循 GPL v2 协议";
ui_print " This kernel is FREE and OPEN SOURCE under GPL v2";
ui_print "**********************************************";
ui_print " ";

# boot install
# Only the kernel image is replaced; the ramdisk is kept untouched.
# split_boot skips ramdisk unpacking, so write_boot must NOT be used
# (it would try to repack a ramdisk that was never extracted).
# Correct flow: split_boot + flash_boot + flash_generic dtbo.
split_boot;

# Kernel files placed in the zip root are replaced automatically:
#   - Image     -> kernel
#   - dtbo.img  -> flashed to the dtbo partition below
flash_boot;

# Flash dtbo.img from the zip root to the dtbo partition
# (flash_boot does not handle dtbo).
flash_generic dtbo;
## end boot install
