function apt_update() {
  sudo apt-get update "$@"
}

function apt_install() {
  sudo env DEBIAN_FRONTEND=noninteractive apt-get install --yes "$@"
}

function apt_add_repository () {
  sudo add-apt-repository --yes --update "$@"
}
