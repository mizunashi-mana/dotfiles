# Dotfiles

My dotfiles and construction documentations.

## Setup

```bash
./setup
```

### Docker Image

```bash
docker build -t mizunashi-mana/dotfiles-devcontainer .
```

Claude version:

```bash
env "GITHUB_TOKEN=$(gh auth token)" docker buildx build \
  --build-arg devcontainer-claude \
  --tag mizunashi-mana/dotfiles/devcontainer-claude \
  --secret id=github-token,env=GITHUB_TOKEN \
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
devenv tasks run pkgs:update
```

### Formatting

```bash
devenv test
```
