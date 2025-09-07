#!/usr/bin/env bash

set -oue pipefail

rm -f /usr/share/doc/just/README*.md

sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/fedora-cisco-openh264.repo
sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/google-chrome.repo
