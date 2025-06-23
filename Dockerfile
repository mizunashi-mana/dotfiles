#syntax=docker/dockerfile:1.4

FROM debian:bookworm-slim

SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

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
useradd --no-create-home --user-group --groups sudo --password '' workuser
mkdir -p /home/workuser
chown workuser:workuser /home/workuser

mkdir -p /var/dotfiles
EOS

COPY ./nix /var/dotfiles/nix
COPY ./tasks /var/dotfiles/tasks
COPY ./flake.nix /var/dotfiles/flake.nix
COPY ./flake.lock /var/dotfiles/flake.lock
COPY ./setup.sh /var/dotfiles/setup.sh

USER workuser
WORKDIR /var/dotfiles
ENV \
  USER=workuser \
  PATH=/usr/local/bin:/usr/bin:/bin:/home/workuser/.nix-profile/bin

RUN <<EOS
./tasks/nix/install
EOS

COPY ./docker/nix.conf /etc/nix/nix.conf

RUN <<EOS
./setup.sh --hostname devcontainer
nix store gc
EOS

USER root
RUN <<EOS
/sbin/usermod --shell /home/workuser/.nix-profile/bin/fish workuser
DEBIAN_FRONTEND=noninteractive apt-get remove -y \
  curl \
  xz-utils
DEBIAN_FRONTEND=noninteractive apt-get autoremove -y --purge
rm -rf /var/lib/apt/lists/*
EOS

USER workuser

CMD ["/home/workuser/.nix-profile/bin/fish", "--login"]
