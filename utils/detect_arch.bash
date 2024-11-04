function detect_arch() {
  case "$(uname -m)" in
  'arm64'|'aarch64' )
    export ARCH='aarch64'
    return 0
    ;;
  'x86_64'|'amd64' )
    export ARCH='amd64'
    return 0
    ;;
  esac

  echo "Unsupported ARCH" >&2
  return 1
}
