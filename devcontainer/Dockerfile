#syntax=docker/dockerfile:1.16.0

FROM mcr.microsoft.com/devcontainers/base:debian
ARG SETUP_HOST=devcontainer
ARG WORKUSER=vscode

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

RUN <<EOS
mkdir -p /var/dotfiles

mkdir -m 0755 /nix
chown "${WORKUSER}:${WORKUSER}" /nix

mkdir -p /workspaces
chown "${WORKUSER}:${WORKUSER}" /workspaces
EOS

USER ${WORKUSER}
ENV PATH=/home/${WORKUSER}/.nix-profile/bin:/usr/local/bin:/usr/bin:/bin

RUN <<EOS
bash -c "$(curl -fsSL https://nixos.org/nix/install)" -s --no-daemon
EOS

COPY ./nix /var/dotfiles/nix
COPY ./tasks /var/dotfiles/tasks
COPY ./flake.nix /var/dotfiles/flake.nix
COPY ./flake.lock /var/dotfiles/flake.lock
COPY ./setup.sh /var/dotfiles/setup.sh

WORKDIR /var/dotfiles
RUN --mount=type=secret,id=nix-config,env=NIX_CONFIG \
<<EOS
rm -rf "/home/${WORKUSER}"/{.bashrc,.profile}
env TRACE=1 "USER=$WORKUSER" ./setup.sh --hostname "$SETUP_HOST"
nix store gc
EOS

COPY ./devcontainer/updateUID.sh /var/docker-dotfiles/updateUID.sh

USER root
RUN <<EOS
rm -rf /var/dotfiles

/sbin/groupmod --gid 71 "$(getent group 20 | cut -d: -f1)"
EOS

USER ${WORKUSER}
WORKDIR /home/${WORKUSER}

CMD ["fish", "--login"]
