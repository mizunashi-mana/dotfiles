#!/usr/bin/env bash

set -euo pipefail
[ -n "${TRACE:-}" ] && set -x

TARGET_USER="$(id -nu)"
FISH_PATH="$(which fish)"

if ! [[ -x /usr/local/bin/git ]]; then
	sudo ln -sf "$HOME/.nix-profile/bin/git" /usr/local/bin/git
fi

if ! grep "$FISH_PATH" /etc/shells >/dev/null 2>&1; then
	echo "$FISH_PATH" | sudo tee --append /etc/shells
fi

if ! getent passwd "$TARGET_USER" | grep "$FISH_PATH" >/dev/null 2>&1; then
	sudo /sbin/usermod --shell "$FISH_PATH" "$TARGET_USER"
fi
