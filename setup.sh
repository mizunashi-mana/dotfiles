#!/usr/bin/env bash

set -euo pipefail
[ -n "${TRACE:-}" ] && set -x

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
TASKS_DIR="$SCRIPT_DIR/tasks"

usage() {
  cat <<EOF
Usage: $0 [options]

Options:
  -h, --help        Show this help message and exit
  --hostname SHORT  Set the short hostname (default: derived from the system)

Environment variables:
  TRACE=1           Set to any value to enable script tracing (set -x)

Examples:
  TRACE=1 $0
EOF
}

HOSTNAME_SHORT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
  -h | --help)
    usage
    exit 0
    ;;
  --hostname)
    if [[ -n ${2:-} ]]; then
      HOSTNAME_SHORT="$2"
      shift 2
    else
      echo "Error: --hostname requires a value." >&2
      usage
      exit 1
    fi
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage
    exit 1
    ;;
  esac
done

if [[ -z $HOSTNAME_SHORT ]]; then
  if ! type hostname &>/dev/null 2>&1; then
    HOSTNAME_SHORT="$(cat /etc/hostname)"
  elif hostname --short &>/dev/null; then
    HOSTNAME_SHORT="$(hostname --short)"
  else
    HOSTNAME_SHORT="$(hostname -s)"
  fi
fi
HOSTNAME_SHORT="$(echo "$HOSTNAME_SHORT" | tr '[:upper:]' '[:lower:]')"

"$TASKS_DIR/nix/install"

case "$HOSTNAME_SHORT" in
'macbook-air-2nd' | 'opl2401-013')
  "$TASKS_DIR/homebrew/install"
  ;;
esac

case "$HOSTNAME_SHORT" in
'macbook-air-2nd' | 'opl2401-013')
  sudo nix --extra-experimental-features 'flakes nix-command' \
    run nix-darwin \
    -- switch --flake ".#$HOSTNAME_SHORT" --show-trace
  ;;
'devcontainer' | 'devcontainer-claude')
  nix --extra-experimental-features 'flakes nix-command' \
    run home-manager \
    -- switch --flake ".#$HOSTNAME_SHORT" --show-trace --impure
  ;;
*)
  echo "Unknown host: $HOSTNAME_SHORT" >&2
  usage
  exit 1
  ;;
esac
