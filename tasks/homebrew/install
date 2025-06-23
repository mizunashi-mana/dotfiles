#!/usr/bin/env bash

set -euo pipefail
[ -n "${TRACE:-}" ] && set -x

if ! type brew >/dev/null 2>&1; then
  # ref: https://brew.sh/
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
