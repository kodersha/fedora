#!/usr/bin/env bash
set -oue pipefail

# Update initramfs for the current kernel only
akmods --force
dracut -f --regenerate-all
