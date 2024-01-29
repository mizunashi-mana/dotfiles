function homebrew_supported() {
  if [ "$OS_ID" != 'macOS' ] && [ "$ARCH" != 'x86_64' ]; then
    echo "Homebrew is not supported non Intel arch on Linux. Skip install Homebrew." >&2
    export USE_HOMEBREW=false
    return 0
  fi

  export USE_HOMEBREW=true
}
