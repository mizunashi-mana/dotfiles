#syntax=docker/dockerfile:1.16.0

FROM mcr.microsoft.com/devcontainers/base:debian
ARG SETUP_HOST=devcontainer
ARG WORKUSER=vscode

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

RUN <<EOS
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  'sudo=1.9*' \
  'curl=7.88.*' \
  'xz-utils=5.4.*' \
  'ca-certificates=20230311*'
rm -rf /var/lib/apt/lists/*
EOS

RUN <<EOS
mkdir -p /var/dotfiles

mkdir -m 0755 /nix
chown "${WORKUSER}:${WORKUSER}" /nix

mkdir -p /workspaces
chown "${WORKUSER}:${WORKUSER}" /workspaces
EOS

USER ${WORKUSER}
ENV \
  USER=${WORKUSER} \
  PATH=/usr/local/bin:/usr/bin:/bin:/home/${WORKUSER}/.nix-profile/bin

RUN <<EOS
bash -c "$(curl -fsSL https://nixos.org/nix/install)" -s --no-daemon
EOS

COPY ./docker/nix.conf /etc/nix/nix.conf
COPY ./nix /var/dotfiles/nix
COPY ./tasks /var/dotfiles/tasks
COPY ./flake.nix /var/dotfiles/flake.nix
COPY ./flake.lock /var/dotfiles/flake.lock
COPY ./setup.sh /var/dotfiles/setup.sh

WORKDIR /var/dotfiles
RUN --mount=type=secret,id=github-token,env=NIX_GITHUB_TOKEN \
<<EOS
rm -rf /home/${WORKUSER}/{.bashrc,.profile}
env TRACE=1 ./setup.sh --hostname "$SETUP_HOST"
nix store gc
EOS

USER root
WORKDIR /home/${WORKUSER}
RUN <<EOS
/sbin/usermod --shell "/home/${WORKUSER}/.nix-profile/bin/fish" "${WORKUSER}"
DEBIAN_FRONTEND=noninteractive apt-get remove -y \
  curl \
  xz-utils
DEBIAN_FRONTEND=noninteractive apt-get autoremove -y --purge
rm -rf /var/lib/apt/lists/*
rm -rf /var/dotfiles
EOS

USER ${WORKUSER}

CMD ["/home/${WORKUSER}/.nix-profile/bin/fish", "--login"]
