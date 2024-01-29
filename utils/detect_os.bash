function detect_os() {
  if type sw_vers >/dev/null 2>&1; then
    DETECT_RESULT="$(sw_vers)"

    case "$(echo "$DETECT_RESULT" | grep 'ProductName:' | awk '{print $2}')" in
      'macOS' )
        export OS_ID='macOS'
        export OS_VERSION="$(echo "$DETECT_RESULT" | grep 'ProductVersion:' | awk '{print $2}')"
        return 0
        ;;
    esac
  fi

  if [ -e /etc/os-release ]; then
    source /etc/os-release
    case "$ID" in
      debian )
        export OS_ID='Debian'
        export OS_VERSION="$VERSION_ID"
        export COMPATIBLE_UBUNTU_CODENAME="$(debian_to_ubuntu_codename "$VERSION_CODENAME")"
        return 0
        ;;
      ubuntu )
        export OS_ID='Ubuntu'
        export OS_VERSION="$VERSION_ID"
        export COMPATIBLE_UBUNTU_CODENAME="$VERSION_CODENAME"
        return 0
        ;;
    esac
  fi

  echo "Unsupported OS" >&2
  return 1
}

function debian_to_ubuntu_codename() {
  case "$1" in
    bookworm )
      echo 'jammy'
      return 0
      ;;
    bullseye )
      echo 'focal'
      return 0
      ;;
    buster )
      echo 'bionic'
      return 0
      ;;
    * )
      echo "Unsupported codename: $1" >&2
      return 1
  esac
}
