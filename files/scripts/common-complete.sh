#!/usr/bin/env bash

set -oue pipefail

ln -sf ../run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
