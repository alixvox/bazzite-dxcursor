#!/usr/bin/bash

source /usr/lib/ublue/setup-services/libsetup.sh

version-script cursor-extensions-dx user 1 || exit 1

set -x

# Setup Cursor (same pattern as VS Code: skel settings + DX extensions)
if test ! -e "$HOME"/.config/Cursor/User/settings.json; then
	mkdir -p "$HOME"/.config/Cursor/User
	cp -f /etc/skel/.config/Cursor/User/settings.json "$HOME"/.config/Cursor/User/settings.json
fi

cursor --install-extension ms-vscode-remote.remote-containers
cursor --install-extension ms-vscode-remote.remote-ssh
cursor --install-extension ms-azuretools.vscode-containers
