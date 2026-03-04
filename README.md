# Bazzite DX Cursor

A [Bazzite](https://github.com/ublue-os/bazzite)-based image that adds [Cursor](https://cursor.com) alongside the existing [Bazzite DX](https://github.com/ublue-os/bazzite-dx) developer tooling (VS Code, Docker, etc.). Cursor is integrated in the same way as VS Code: installed in the image and configured on first login (default settings, Remote - Containers, Remote - SSH, Docker extension).

**What this is:** A fork of [bazzite-dx](https://github.com/ublue-os/bazzite-dx) with Cursor installed in the image, first-login hooks for Cursor settings and extensions, and automated version checks so the image can be rebuilt when a new Cursor release is available.

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

- Everything from **Bazzite** and **Bazzite DX** (VS Code, Docker, ublue-setup-services, first-login hooks, etc.).
- **Cursor** installed from the official RPM (version pinned in `build_files/CURSOR_VERSION`; the build downloads the matching RPM).
- First-login setup for Cursor: default settings (font, updates disabled) and extensions (Remote - Containers, Remote - SSH, Docker), mirroring the VS Code DX setup.
- **VS Code remains**; Cursor is added alongside it.

---

## Cursor version and updates

- The image is built with a specific Cursor version stored in **`build_files/CURSOR_VERSION`** (e.g. `2.6.11`). The download URL uses major.minor (e.g. `2.6`); the file keeps the full version for tracking.
- A **GitHub Action** (`.github/workflows/check-cursor-version.yml`) runs daily and, when the Cursor API reports a newer version, updates `CURSOR_VERSION`, pushes to the default branch, and triggers the image build. So updated images can be published automatically when Cursor releases a new version.
- Cursor’s in-app updates are turned off by default (`update.mode: "none"` in the seeded settings); updates are intended to come from new image builds/rebase.

---

## Build your own (fork and sign)

1. **Fork this repo** (or clone and push to your own GitHub repo).
2. **Set up image signing** so the workflow can sign the image and users can rebase with `ostree-image-signed`:
   - See **[docs/SIGNING-SETUP.md](docs/SIGNING-SETUP.md)** for step-by-step instructions (Cosign key pair, `SIGNING_SECRET` and optional `COSIGN_PASSWORD` in GitHub Actions secrets, and replacing `cosign.pub` in the repo).
   - Summary: generate a key pair with `cosign generate-key-pair`, put the **public** key in the repo as `cosign.pub`, and store the **private** key in GitHub under **Settings → Secrets and variables → Actions** as **`SIGNING_SECRET`**.
3. **Enable GitHub Actions** for the repo (Settings → Actions → allow actions).
4. Push to the default branch or trigger the **Build Bazzite DX** workflow; the image will be built and pushed to `ghcr.io/YOUR_ORG/bazzite-dxcursor` (and `-gnome`, `-nvidia`, `-nvidia-gnome`).

Without `SIGNING_SECRET`, the **Sign container image** step fails; you can either add the secret (recommended) or temporarily disable that step and use `ostree-unverified-registry` when rebasing.

---

## Repo layout (quick reference)

| What                | Where |
|---------------------|--------|
| Cursor version pin  | `build_files/CURSOR_VERSION` |
| Cursor install      | `build_files/20-install-apps.sh` |
| Cursor first-login  | `system_files/usr/share/ublue-os/user-setup.hooks.d/12-cursor-extensions.sh` |
| Cursor default settings | `system_files/etc/skel/.config/Cursor/User/settings.json` |
| Version-check workflow | `.github/workflows/check-cursor-version.yml` |
| Signing setup       | `docs/SIGNING-SETUP.md` |
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

---

## Acknowledgments

- [Universal Blue](https://universal-blue.org/) and [Bazzite](https://github.com/ublue-os/bazzite)
- [Bazzite DX](https://github.com/ublue-os/bazzite-dx) for the developer-edition base and VS Code/Docker integration
- [Cursor](https://cursor.com) by Anysphere
