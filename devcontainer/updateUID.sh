#!/usr/bin/env bash

set -euo pipefail
[ -n "${TRACE:-}" ] && set -x

usage() {
  cat <<EOF
Usage: $0 [options]

Options:
  -h, --help        Show this help message and exit
  --user USER       Set the target user (default: current user)
  --uid UID         Set the target user ID (UID)
  --gid GID         Set the target group ID (GID)

Environment variables:
  TRACE=1           Set to any value to enable script tracing (set -x)

Examples:
  TRACE=1 $0
EOF
}

TARGET_USER="${USER:-}"
TARGET_UID=""
TARGET_GID=""
while [[ $# -gt 0 ]]; do
  case "$1" in
  -h | --help)
    usage
    exit 0
    ;;
  --user)
    if [[ -n ${2:-} ]]; then
      TARGET_USER="$2"
      shift 2
    else
      echo "Error: --user requires a value." >&2
      usage
      exit 1
    fi
    ;;
  --uid)
    if [[ -n ${2:-} ]]; then
      TARGET_UID="$2"
      shift 2
    else
      echo "Error: --uid requires a value." >&2
      usage
      exit 1
    fi
    ;;
  --gid)
    if [[ -n ${2:-} ]]; then
      TARGET_GID="$2"
      shift 2
    else
      echo "Error: --gid requires a value." >&2
      usage
      exit 1
    fi
    ;;
  --)
    shift
    break
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage
    exit 1
    ;;
  esac
done

if [ -z "$TARGET_USER" ]; then
  echo "Error: --user must be specified." >&2
  usage
  exit 1
fi

if [ -z "$TARGET_UID" ]; then
  echo "Error: --uid must be specified." >&2
  usage
  exit 1
fi

if [ -z "$TARGET_GID" ]; then
  echo "Error: --gid must be specified." >&2
  usage
  exit 1
fi

OLD_UID="$(id -u "$TARGET_USER")"
OLD_GID="$(id -g "$TARGET_USER")"

if [ "$OLD_UID" = "$TARGET_UID" ] && [ "$OLD_GID" = "$TARGET_GID" ]; then
  echo "No changes needed for user '$TARGET_USER' (UID: $TARGET_UID, GID: $TARGET_GID)."
  exit 0
fi

if [ "$OLD_UID" != "$TARGET_UID" ] && getent passwd "$TARGET_UID" >/dev/null; then
  echo "Error: UID '$TARGET_UID' already exists." >&2
  exit 1
fi

if [ "$OLD_GID" != "$TARGET_GID" ] && getent group "$TARGET_GID" >/dev/null; then
  echo "Error: GID '$TARGET_GID' already exists." >&2
  exit 1
fi

if [ "$OLD_UID" != "$TARGET_UID" ] || [ "$OLD_GID" != "$TARGET_GID" ]; then
  sed -i -e "s/\(${TARGET_USER}:[^:]*:\)[^:]*:[^:]*/\1${TARGET_UID}:${TARGET_GID}/" /etc/passwd
fi

if [ "$OLD_GID" != "$TARGET_GID" ]; then
  sed -i -e "s/\([^:]*:[^:]*:\)${OLD_GID}:/\1${TARGET_GID}:/" /etc/group
fi

for dir in "/home/$TARGET_USER" /nix /workspaces; do
  chown -R "$TARGET_UID:$TARGET_GID" "$dir"
done
