#!/usr/bin/env bash

set -euo pipefail
[ -n "${TRACE:-}" ] && set -x

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
TASKS_DIR="$SCRIPT_DIR/tasks"

"$TASKS_DIR/nix/install"

if hostname --short &>/dev/null; then
  HOSTNAME_SHORT="$(hostname --short)"
else
  HOSTNAME_SHORT="$(hostname -s)"
fi
HOSTNAME_SHORT="$(echo "$HOSTNAME_SHORT" | tr '[:upper:]' '[:lower:]')"

case "$HOSTNAME_SHORT" in
'macbook-air-2nd' | 'opl2401-013')
  "$TASKS_DIR/homebrew/install"
  sudo nix run nix-darwin \
    --extra-experimental-features 'flakes nix-command' \
    -- switch --flake ".#$HOSTNAME_SHORT" --show-trace
  ;;
*)
  echo "Unknown host."
  exit 1
  ;;
esac
