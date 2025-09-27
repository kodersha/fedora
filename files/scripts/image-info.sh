#!/usr/bin/env bash

set -ouex pipefail

IMAGE_VENDOR="kodersha"
IMAGE_NAME="fedora"
IMAGE_PRETTY_NAME="Fedora Silverblue"
IMAGE_LIKE="fedora"
VERSION_CODENAME=""

FEDORA_MAJOR_VERSION=$(awk -F= '/VERSION_ID/ {print $2}' /etc/os-release)
BASE_IMAGE_NAME="Silverblue $FEDORA_MAJOR_VERSION"
BASE_IMAGE="quay.io/fedora-ostree-desktops/silverblue"

# OS Release File
sed -i "s/^VARIANT_ID=.*/VARIANT_ID=$IMAGE_NAME/" /usr/lib/os-release
sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"${IMAGE_PRETTY_NAME}\"/" /usr/lib/os-release
sed -i "s/^NAME=.*/NAME=\"$IMAGE_PRETTY_NAME\"/" /usr/lib/os-release
sed -i "s/^ID=.*/ID=\"$IMAGE_NAME\"/" /usr/lib/os-release
sed -i "s/^DEFAULT_HOSTNAME=.*/DEFAULT_HOSTNAME=\"${IMAGE_PRETTY_NAME,}\"/" /usr/lib/os-release
sed -i "s/^ID=fedora/ID=${IMAGE_PRETTY_NAME,}\nID_LIKE=\"${IMAGE_LIKE}\"/" /usr/lib/os-release
sed -i "/^REDHAT_BUGZILLA_PRODUCT=/d; /^REDHAT_BUGZILLA_PRODUCT_VERSION=/d; /^REDHAT_SUPPORT_PRODUCT=/d; /^REDHAT_SUPPORT_PRODUCT_VERSION=/d" /usr/lib/os-release

#if [[ -n "${SHA_HEAD_SHORT:-}" ]]; then
#  echo "BUILD_ID=\"$SHA_HEAD_SHORT\"" >> /usr/lib/os-release
#fi

# Fix issues caused by ID no longer being fedora
sed -i "s/^EFIDIR=.*/EFIDIR=\"fedora\"/" /usr/sbin/grub2-switch-to-blscfg
