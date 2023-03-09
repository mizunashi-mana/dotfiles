function detect_os() {
  if type sw_vers >/dev/null 2>&1; then
    DETECT_RESULT="$(sw_vers)"

    case "$(echo "$DETECT_RESULT" | grep 'ProductName:' | awk '{print $2}')" in
      'macOS' )
        export OS_ID='macOS'
        export OS_VERSION="$(echo "$DETECT_RESULT" | grep 'ProductVersion:' | awk '{print $2}')"
        return 0
        ;;
      * )
        echo "Unsupported OS: $DETECT_RESULT" >&2
        return 1
        ;;
    esac
  fi

  if [ -e /etc/debian_version ]; then
    export OS_ID='Debian'
    export OS_VERSION="$(cat /etc/debian_version)"
    return 0
  fi

  echo "Unsupported OS" >&2
  return 1
}
