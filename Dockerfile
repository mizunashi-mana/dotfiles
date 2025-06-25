#syntax=docker/dockerfile:1.4

FROM debian:bookworm-slim
ARG SETUP_HOST=devcontainer

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
mkdir -m 0755 /nix
chown workuser /nix
EOS

COPY ./nix /var/dotfiles/nix
COPY ./tasks /var/dotfiles/tasks
COPY ./flake.nix /var/dotfiles/flake.nix
COPY ./flake.lock /var/dotfiles/flake.lock
COPY ./setup.sh /var/dotfiles/setup.sh

USER workuser
ENV \
  USER=workuser \
  PATH=/usr/local/bin:/usr/bin:/bin:/home/workuser/.nix-profile/bin

RUN <<EOS
bash -c "$(curl -fsSL https://nixos.org/nix/install)" -s --no-daemon
EOS

COPY ./docker/nix.conf /etc/nix/nix.conf

WORKDIR /var/dotfiles
RUN <<EOS
TRACE=1 ./setup.sh --hostname "$SETUP_HOST"
nix store gc
EOS

USER root
WORKDIR /home/workuser
RUN <<EOS
/sbin/usermod --shell /home/workuser/.nix-profile/bin/fish workuser
DEBIAN_FRONTEND=noninteractive apt-get remove -y \
  curl \
  xz-utils
DEBIAN_FRONTEND=noninteractive apt-get autoremove -y --purge
rm -rf /var/lib/apt/lists/*
rm -rf /var/dotfiles
EOS

USER workuser

CMD ["/home/workuser/.nix-profile/bin/fish", "--login"]
