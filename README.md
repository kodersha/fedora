# fedora &nbsp; [![build-ublue](https://github.com/kodersha/fedora/actions/workflows/build.yml/badge.svg)](https://github.com/kodersha/fedora/actions/workflows/build.yml)

![fastfetch](/.readme/fastfetch.png)

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

### Nix Package Manager

```
sh <(curl -L https://nixos.org/nix/install) --daemon
```

## ISO

```
mkdir ./iso && sudo podman run --rm --privileged --volume ./iso:/build-container-installer/build --security-opt label=disable --pull=newer ghcr.io/jasonn3/build-container-installer:latest IMAGE_REPO=ghcr.io/kodersha IMAGE_NAME=fedora IMAGE_TAG=latest VARIANT=Server VERSION=40
```

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/kodersha/fedora
```

## Known Issues

- After installation, you need to run `sudo nano /etc/hosts` and add the line `127.0.1.1   fedora`. Otherwise, the browser will start very slowly. This is related to the DNS entry in `/etc/systemd/resolved.conf.d/00-custom.conf`.
- You need to run the command `sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0` to apply GTK theme to Flatpak applications.

---

Sources:

- [Silverblue Nix](https://gitlab.com/ahayzen/silverblue-nix)