#!/usr/bin/env bash
set -oue pipefail

# Rebuild kernel modules (e.g. NVIDIA) for the current kernel
akmods --force --kernels "$(uname -r)"

# Update initramfs for the current kernel only
dracut -f "/boot/initramfs-$(uname -r).img" "$(uname -r)"
