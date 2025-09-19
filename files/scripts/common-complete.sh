#!/usr/bin/env bash
set -oue pipefail

# Update initramfs for the current kernel only
dracut -f --regenerate-all
