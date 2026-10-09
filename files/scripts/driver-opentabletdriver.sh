#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
set -oue pipefail

dnf5 -y install https://github.com/OpenTabletDriver/OpenTabletDriver/releases/latest/download/opentabletdriver-0.6.7-1.x86_64.rpm
dracut --regenerate-all --force
