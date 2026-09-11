#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="evoos"
iso_label="EVOOS_$(date +%Y%m)"
iso_publisher="EvoOS <https://example.com>"
iso_application="EvoOS - Live/Install medium"
iso_version="$(date +%Y.%m.%d)"
install_dir="evoos"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/etc/sudoers.d"]="0:0:750"
  ["/etc/sudoers.d/g_wheel"]="0:0:440"
)
