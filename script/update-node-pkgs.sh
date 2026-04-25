#!/usr/bin/env bash

set -euo pipefail
[ -n "${TRACE:-}" ] && set -x

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
NODE_PKGS_DIR="$SCRIPT_DIR/../nix/packages/node-pkgs"

for pkg_dir in "$NODE_PKGS_DIR"/*/; do
	pkg_name=$(basename "$pkg_dir")
	echo "Updating $pkg_name..."
	(cd "$pkg_dir" && npm update --package-lock-only --ignore-scripts)
done

echo "Done."
