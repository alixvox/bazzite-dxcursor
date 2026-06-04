# Bazzite DX Cursor

A [Bazzite](https://github.com/ublue-os/bazzite)-based image that adds [Cursor](https://cursor.com) alongside the existing [Bazzite DX](https://github.com/ublue-os/bazzite-dx) developer tooling (VS Code, Docker, etc.). Cursor is integrated in the same way as VS Code: installed in the image and configured on first login (default settings, Remote - Containers, Remote - SSH, Docker extension).

**What this is:** A fork of [bazzite-dx](https://github.com/ublue-os/bazzite-dx) with Cursor installed in the image, first-login hooks for Cursor settings and extensions, and a daily image build so new Cursor releases are picked up automatically.

---

## Installation (rebase)

You should be on a Bazzite-based system (e.g. Bazzite or Bazzite-DX). Replace `YOUR_ORG` with your GitHub username or organization that publishes the image.

### KDE Plasma (default)

```bash
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/YOUR_ORG/bazzite-dxcursor:stable
```

### GNOME

```bash
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/YOUR_ORG/bazzite-dxcursor-gnome:stable
```

### NVIDIA variants

**KDE Plasma with NVIDIA:**

```bash
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/YOUR_ORG/bazzite-dxcursor-nvidia:stable
```

**GNOME with NVIDIA:**

```bash
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/YOUR_ORG/bazzite-dxcursor-nvidia-gnome:stable
```

### Unverified image (no signing)

If the image is not signed, use:

```bash
sudo rpm-ostree rebase ostree-unverified-registry:docker://ghcr.io/YOUR_ORG/bazzite-dxcursor:stable
```

(Replace with the variant you need: `bazzite-dxcursor-gnome`, `-nvidia`, or `-nvidia-gnome`.)

After rebasing, **reboot** to complete the switch. On first login, user-setup hooks install default settings and extensions for both VS Code and Cursor.

### Desktop environment warning

**Do not switch between GNOME and KDE variants.** Rebase only to the variant that matches your current desktop (e.g. if you are on GNOME, use the `-gnome` image). Switching via rebase can break the installation.

---

## What’s in the image

- Everything from **Bazzite** and **Bazzite DX** (VS Code, Docker, ublue-setup-services, virtualization/ROCm tooling, first-login hooks, etc.).
- **Cursor** installed from the official RPM. At build time the latest version is fetched from the Cursor API; `build_files/CURSOR_VERSION` is an offline fallback only.
- First-login setup for Cursor: default settings (font, updates disabled) and extensions (Remote - Containers, Remote - SSH, Docker), mirroring the VS Code DX setup.
- **VS Code remains**; Cursor is added alongside it.

---

## Cursor version and updates

- The image installs Cursor at build time. The build queries the Cursor download API (`https://cursor.com/api/download?platform=linux-x64&releaseTrack=latest`) for the current version and installs the matching RPM. The download URL uses major.minor (e.g. `3.6`).
- If the API is unreachable during a build, the build falls back to the version stored in **`build_files/CURSOR_VERSION`**. Keep this file roughly current so the fallback is sensible.
- The build workflow (`.github/workflows/build.yml`) runs on a daily schedule, so new Cursor releases are normally picked up within a day and published as a new image.
- Cursor’s in-app updates are turned off by default (`update.mode: "none"` in the seeded settings); updates are intended to come from new image builds/rebase.

---

## Build your own (fork and sign)

1. **Fork this repo** (or clone and push to your own GitHub repo).
2. **Set up image signing** so the workflow can sign the image and users can rebase with `ostree-image-signed`:
   - Generate a key pair with `cosign generate-key-pair`, commit the **public** key to the repo as `cosign.pub`, and store the **private** key in GitHub under **Settings → Secrets and variables → Actions** as **`SIGNING_SECRET`**.
   - If you created the key with a password, also set **`COSIGN_PASSWORD`** as an Actions secret.
   - See the upstream Bazzite ["Build your own"](https://docs.bazzite.gg/Advanced/build_your_own/) documentation for more detail on signing.
3. **Enable GitHub Actions** for the repo (Settings → Actions → allow actions).
4. Push to the default branch or trigger the **Build Bazzite DX Cursor** workflow; the image will be built and pushed to `ghcr.io/YOUR_ORG/bazzite-dxcursor` (and `-gnome`, `-nvidia`, `-nvidia-gnome`).

Without `SIGNING_SECRET`, the **Sign container image** step fails; you can either add the secret (recommended) or temporarily disable that step and use `ostree-unverified-registry` when rebasing.

---

## Repo layout (quick reference)

| What                | Where |
|---------------------|--------|
| Cursor version fallback | `build_files/CURSOR_VERSION` |
| Cursor install      | `build_files/20-install-apps.sh` |
| Cursor first-login  | `system_files/usr/share/ublue-os/user-setup.hooks.d/12-cursor-extensions.sh` |
| Cursor default settings | `system_files/etc/skel/.config/Cursor/User/settings.json` |
| Build workflow      | `.github/workflows/build.yml` |
| Image signing key   | `cosign.pub` |
| Rebase checklist    | `REBASE-CHECKLIST.md` |

---

## License and attribution

This project is a derivative of:

- **[Bazzite](https://github.com/ublue-os/bazzite)** (Universal Blue)
- **[Bazzite DX](https://github.com/ublue-os/bazzite-dx)**

The original works are licensed under the **Apache License 2.0**. This repository keeps the same license; see **[LICENSE](LICENSE)**.

You do **not** need to change the license for your fork. If you distribute your own build or modifications:

- **Keep the LICENSE file** and any existing attribution (e.g. in NOTICE or README).
- **Retain upstream copyright/attribution** for Bazzite and Bazzite-DX where appropriate (this README and the NOTICE file do that).
- You may add your own copyright line for your changes (e.g. in a NOTICE file or at the bottom of the README) if you want; it is not required by Apache 2.0 for a fork, but it makes your contributions clear.

A **NOTICE** file is included in this repo to satisfy Apache 2.0 attribution for upstream works. If you fork and add your own modifications, you can add your name/copyright there or in the README.

Cursor itself is proprietary software by **Anysphere** and is subject to its own license and terms; this image only installs it from Cursor’s official RPM and does not redistribute it.

---

## Acknowledgments

- [Universal Blue](https://universal-blue.org/) and [Bazzite](https://github.com/ublue-os/bazzite)
- [Bazzite DX](https://github.com/ublue-os/bazzite-dx) for the developer-edition base and VS Code/Docker integration
- [Cursor](https://cursor.com) by Anysphere
