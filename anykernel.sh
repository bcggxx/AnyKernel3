### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

# =====================================================================
# 内核：n0 Kernel for Xiaomi Pad 6 (pipa)
# 维护者：bcggxx
# 源代码：https://github.com/bcggxx/android_kernel_xiaomi_n0_pipa
# 许可证：GPL v2（开源免费）
# =====================================================================

### AnyKernel 全局属性配置 / Global Properties ###
properties() { '
# 内核名称 / Kernel name
kernel.string=n0 Kernel by bcggxx @ Xiaomi Pad 6 (pipa)

# 启用设备检测（仅支持 pipa）/ Enable device check (pipa only）
do.devicecheck=1

# 不需要内核模块 / Do not install modules
do.modules=0

# 非 systemless 模式 / Not systemless
do.systemless=0

# 安装完成后清理临时文件 / Clean up temp files after install
do.cleanup=1

# 安装中止时清理 / Clean up on abort
do.cleanuponabort=1

# 设备名称 - 小米平板6 代号 pipa / Device name - Xiaomi Pad 6 codename pipa
device.name1=pipa

# 支持的 Android 版本（当前仅支持 Android 15 及以下）/ Supported Android versions (Android 15 and below only)
supported.versions=

# 安全补丁级别（留空表示全部）/ Supported security patch levels
supported.patchlevels=

# 厂商补丁级别（留空表示全部）/ Supported vendor patch levels
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel 安装流程 / Install ###

# =====================================================================
# boot 分区文件属性设置 / Boot partition file attributes
# =====================================================================
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# =====================================================================
# Boot 分区变量 / Boot partition variables
# =====================================================================
# 自动检测分区 / Auto-detect boot partition
BLOCK=auto;

# 启用 A/B 插槽检测（pipa 是 A/B 设备）/ Enable slot detection (pipa is A/B device)
IS_SLOT_DEVICE=1;

# 自动检测 ramdisk 压缩格式 / Auto-detect ramdisk compression
RAMDISK_COMPRESSION=auto;

# 自动处理 AVB vbmeta 标志 / Auto-handle AVB vbmeta flag
PATCH_VBMETA_FLAG=auto;

# =====================================================================
# 导入 AnyKernel3 核心函数（不可删除！）
# Import AnyKernel3 core functions (DO NOT REMOVE!)
# =====================================================================
. tools/ak3-core.sh;

# =====================================================================
# 输出内核信息 / Print kernel info
# =====================================================================
ui_print " ";
ui_print "**********************************************";
ui_print " 小米平板6 (pipa) 专用内核";
ui_print " n0 Kernel for Xiaomi Pad 6 (pipa)";
ui_print "**********************************************";
ui_print " 维护者：bcggxx / Maintainer: bcggxx";
ui_print "**********************************************";
ui_print " 源码：https://github.com/bcggxx/android_kernel_xiaomi_n0_pipa";
ui_print " Source: https://github.com/bcggxx/android_kernel_xiaomi_n0_pipa";
ui_print "**********************************************";
ui_print " 本内核是免费且开源的，遵循 GPL v2 协议";
ui_print " This kernel is FREE and OPEN SOURCE under GPL v2";
ui_print "**********************************************";
ui_print " 仅适用于 Android 15 及以下 / For Android 15 and below";
ui_print "**********************************************";
ui_print " ";

# =====================================================================
# 解压 boot 镜像 / Dump and unpack boot image
# 如果只需要替换 kernel 而不修改 ramdisk，可使用 split_boot
# Use split_boot to skip ramdisk unpack if only replacing kernel
# =====================================================================
split_boot;

# =====================================================================
# 内核文件已自动替换（Image / Image.gz, dtbo.img, dtb 放在 zip 根目录即可）
# Kernel files are automatically replaced (place Image / Image.gz,
# dtbo.img, dtb in the zip root directory)
# =====================================================================
# 说明 / Note:
# AnyKernel3 会自动检测并替换以下文件（放置于刷机包根目录）：
# AnyKernel3 automatically detects and replaces these files
# (place them in the zip root directory):
#   - Image / Image.gz  -> 内核 / Kernel (自动识别，不会冲突)
#                           Auto-detected, no conflict
#   - dtbo.img          -> DTBO 分区镜像 / DTBO partition image
#   - dtb               -> 设备树 blob / Device tree blob
# 无需额外操作 / No additional operations needed.
# =====================================================================
# 注意 / Note:
# pipa (小米平板6) 是传统非 GKI 设备，只有 boot 分区，没有 init_boot。
# pipa (Xiaomi Pad 6) is a traditional non-GKI device with only a
# boot partition — no init_boot partition.
# 既然我们不修改 ramdisk，使用 split_boot 后就不能用 write_boot：
# write_boot 内部会调用 repack_ramdisk，它需要已解压的 ramdisk 目录
# 才能工作，但 split_boot 跳过了解压步骤，会导致失败。
# Since we don't modify ramdisk, after split_boot we must NOT use
# write_boot: write_boot internally calls repack_ramdisk, which
# requires the extracted ramdisk directory. But split_boot skips
# extraction, so write_boot would fail.
# 正确做法：split_boot + flash_boot + flash_generic dtbo
# Correct approach: split_boot + flash_boot + flash_generic dtbo
# =====================================================================

# =====================================================================
# 使用原始 ramdisk 重新打包并刷入 boot（不重打包 ramdisk）
# flash_boot: repack and flash boot using original ramdisk
#             (no ramdisk repacking)
# =====================================================================
flash_boot;

# =====================================================================
# 单独刷入 dtbo.img 分区（flash_boot 不处理 dtbo）
# flash_generic dtbo: flash dtbo.img partition separately
#                     (flash_boot does not handle dtbo)
# =====================================================================
flash_generic dtbo;

# =====================================================================
# 安装完成 / Installation complete
# =====================================================================
ui_print " ";
ui_print "**********************************************";
ui_print " Installation complete! 安装完成！";
ui_print " Thanks for using n0 Kernel!";
ui_print " 感谢使用 n0 Kernel！";
ui_print "**********************************************";
ui_print " ";

