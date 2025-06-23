#!/usr/bin/env bash

set -euo pipefail
[ -n "${TRACE:-}" ] && set -x

if ! type nix >/dev/null 2>&1; then
  # ref: https://nixos.org/download/
  bash -c "$(curl -fsSL https://nixos.org/nix/install)"
fi
