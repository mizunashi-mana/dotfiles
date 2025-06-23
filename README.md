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
