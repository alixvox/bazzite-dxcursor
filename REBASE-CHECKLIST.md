# Pre-push and rebase checklist

Use this before pushing and before testing a rebase on your laptop.

---

## 1. Before you push (repo: `bazzite-dxcursor`)

- [ ] **No RPMs in the repo** – You are not shipping the Cursor RPMs in the image; the build downloads them from the Cursor URL. Remove any `*.rpm` from the repo if present (and you’ve removed `*.rpm` from `.gitignore`).
- [ ] **Cursor install** – `build_files/20-install-apps.sh` installs Cursor from the API URL using `build_files/CURSOR_VERSION` (full version; URL uses major.minor). No change needed unless you want to tweak the block.
- [ ] **Cursor post-install** – First-login hook and skel are in place:
  - `system_files/usr/share/ublue-os/user-setup.hooks.d/12-cursor-extensions.sh` – copies skel settings, installs remote-containers, remote-ssh, vscode-containers.
  - `system_files/etc/skel/.config/Cursor/User/settings.json` – default font and `update.mode: "none"`.
- [ ] **Image name** – `.github/workflows/build.yml` “Generate output image ref” uses `github.event.repository.name`, so the image is built as **`bazzite-dxcursor`** (e.g. `ghcr.io/YOUR_ORG/bazzite-dxcursor:latest`). No change needed if the repo is named `bazzite-dxcursor`.
- [ ] **Signing (optional for first test)** – The workflow signs with Cosign using `secrets.SIGNING_SECRET`. If that secret is not set, the **Sign container image** step fails and the workflow will not succeed. To test without signing:
  - Either add a real Cosign key and set `SIGNING_SECRET` (see main Bazzite “Build your own” docs), or
  - Temporarily skip the sign step (e.g. add `if: false` to “Sign container image”) so the image still pushes; on the laptop you would rebase using **unverified** (e.g. `ostree-unverified-registry:docker://ghcr.io/YOUR_ORG/bazzite-dxcursor:latest`).

---

## 2. Push and build

- [ ] Push to your default branch (e.g. `main`).
- [ ] Trigger the **Build Bazzite DX** workflow (or let it run on push if configured).
- [ ] Wait for the build to finish and the image to be pushed to GHCR (e.g. `ghcr.io/YOUR_ORG/bazzite-dxcursor:latest`). If signing is skipped, the image is there but unsigned.

---

## 3. On your laptop (test rebase)

- [ ] **Current Bazzite/Bazzite-DX** – You should be on a Bazzite-based system (e.g. Bazzite or Bazzite-DX) so the rebase target is compatible.
- [ ] **Choose the right variant** – The workflow builds four images. Use the image name that matches the desktop you want:
  | Variant | Image name | Use when you want |
  |---------|------------|--------------------|
  | KDE Plasma (default) | `bazzite-dxcursor` | Default Bazzite-style desktop |
  | **GNOME** | **`bazzite-dxcursor-gnome`** | GNOME desktop |
  | NVIDIA + KDE | `bazzite-dxcursor-nvidia` | NVIDIA drivers, KDE |
  | NVIDIA + GNOME | `bazzite-dxcursor-nvidia-gnome` | NVIDIA drivers, GNOME |
  Do **not** switch between GNOME and KDE by rebasing; pick the variant that matches (or will match) your desktop.
- [ ] **Rebase command** – Replace `YOUR_ORG` with your GitHub org/user. For **GNOME** (signed image):
  ```bash
  sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/YOUR_ORG/bazzite-dxcursor-gnome:latest
  ```
  For **KDE/Plasma** (signed): use `bazzite-dxcursor:latest` (no `-gnome`).
  If you did **not** sign the image, use `ostree-unverified-registry` and the same image name, e.g.:
  ```bash
  sudo rpm-ostree rebase ostree-unverified-registry:docker://ghcr.io/YOUR_ORG/bazzite-dxcursor-gnome:latest
  ```
- [ ] **Reboot** after the rebase. On first login, the user-setup hooks run: VS Code extensions (11) and Cursor extensions (12) plus skel settings for both.
- [ ] **Check Cursor** – Open Cursor; confirm it’s installed, settings are applied, and the DX extensions (e.g. Remote - Containers, Remote - SSH) are available.

---

## 4. Quick reference

| Item | Location / value |
|------|-------------------|
| Repo (actual) | `bazzite-dxcursor/` (child of workspace root) |
| Cursor version pin | `build_files/CURSOR_VERSION` |
| Cursor install | `build_files/20-install-apps.sh` |
| Cursor first-login | `system_files/.../12-cursor-extensions.sh` |
| Cursor skel | `system_files/etc/skel/.config/Cursor/User/settings.json` |
| Image names | `bazzite-dxcursor` (KDE), `bazzite-dxcursor-gnome` (GNOME), `-nvidia`, `-nvidia-gnome`. See README. |
