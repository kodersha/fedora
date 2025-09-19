#!/usr/bin/env bash

set -oue pipefail

akmods --force
dracut --force

ln -sf ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
