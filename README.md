# fedora &nbsp; [![build-ublue](https://github.com/kodersha/fedora/actions/workflows/build.yml/badge.svg)](https://github.com/kodersha/fedora/actions/workflows/build.yml)

## Installation

To rebase an existing atomic Fedora installation to the latest build, first rebase to the unsigned image, to get the proper signing keys and policies installed:
```bash
rpm-ostree rebase ostree-unverified-registry:ghcr.io/kodersha/fedora:latest
```

Reboot to complete the rebase:
```bash
systemctl reboot
```

Then rebase to the signed image, like so:
```bash
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/kodersha/fedora:latest
```

Reboot again to complete the installation:
```bash
systemctl reboot
```

## ISO

```bash
mkdir ./iso && sudo podman run --rm --privileged --volume ./iso:/build-container-installer/build --security-opt label=disable --pull=newer ghcr.io/jasonn3/build-container-installer:latest IMAGE_REPO=ghcr.io/kodersha IMAGE_NAME=fedora IMAGE_TAG=latest VARIANT=Server VERSION=42
```

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/kodersha/fedora
```

---

#### Sources

- [Blue Build](https://blue-build.org/learn/getting-started/)
