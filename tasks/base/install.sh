#!/usr/bin/env bash

set -euo pipefail
[ -n "${TRACE:-}" ] && set -x

if ! type curl >/dev/null 2>&1 && type apt-get >/dev/null 2>&1; then
	sudo apt-get update
	sudo apt-get install -y curl xz-utils
fi
