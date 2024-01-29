#syntax=docker/dockerfile:1.4

FROM debian:bookworm

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

ENV WORK_USER=worker
ENV WORK_DIR=/home/$WORK_USER

RUN <<EOT
    apt-get update
    DEBIAN_FRONTEND=noninteractive \
        apt-get install --no-install-recommends -y \
            sudo \
            locales \
            ca-certificates \

    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        dpkg-reconfigure --frontend=noninteractive locales && \
        update-locale LANG=en_US.UTF-8

    useradd \
        --home-dir "$WORK_DIR" \
        --create-home \
        --user-group \
        "$WORK_USER"
    echo "$WORK_USER ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$WORK_USER"

    apt-get clean
    rm -rf /var/lib/apt/lists/*
EOT

COPY . /usr/share/dotfiles

USER $WORK_USER
WORKDIR $WORK_DIR

ENV USER=$WORK_USER
ENV HOME=$WORK_DIR

RUN <<EOT
    sudo apt-get update
    env \
        TRACE=true \
        NONINTERACTIVE=true \
        /usr/share/dotfiles/setup
EOT

ENTRYPOINT [ "/usr/bin/env" ]
CMD ["fish", "-l"]
