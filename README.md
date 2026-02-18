# Dotfiles

My dotfiles and construction documentations.

## Setup

```bash
./setup.sh
```

### Docker Image

```bash
docker buildx build \
  --file devcontainer/Dockerfile \
  --build-arg SETUP_HOST=devcontainer \
  --tag ghcr.io/mizunashi-mana/dotfiles/devcontainer \
  .
```

Base image (Claude):

```bash
docker buildx build \
  --file devcontainer/Dockerfile \
  --build-arg SETUP_HOST=devcontainer-claude \
  --tag ghcr.io/mizunashi-mana/dotfiles/devcontainer-claude \
  .
```

## How to Contribute

Requirements:

- [devenv](https://devenv.sh/)

Run the below to develop:

```bash
devenv shell
```

### Update packages

```bash
devenv shell update-pkgs
```

### Formatting

```bash
devenv shell lint-all
```

## License Notice

This repository is offered under your choice of the following licenses:

- **Apache License, Version 2.0**  
  You may use, modify, and distribute this repository under the terms of the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0).

- **Mozilla Public License, Version 2.0**  
  You may use, modify, and distribute this repository under the terms of the [Mozilla Public License 2.0](https://www.mozilla.org/MPL/2.0/).

Note: By contributing to or using this repository, you agree to comply with the full text of the license you select.

See [LICENSE](./LICENSE) also.
