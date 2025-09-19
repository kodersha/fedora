#!/usr/bin/env bash
set -oue pipefail

# Update initramfs for the current kernel only
dracut -f "/boot/initramfs-$(uname -r).img" "$(uname -r)"
