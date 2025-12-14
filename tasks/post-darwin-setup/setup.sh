#!/usr/bin/env bash

set -euo pipefail
[ -n "${TRACE:-}" ] && set -x

EXPECT_SHELL="$(grep /fish /etc/shells | tail -1)"

if [ "$SHELL" != "$EXPECT_SHELL" ]; then
	chsh -s "$EXPECT_SHELL"
fi
