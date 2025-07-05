# dotfiles Development Guide

This file contains information to help Claude Code understand and work with this dotfiles repository.

## Project Structure

This is a Nix-based dotfiles repository using:

- Nix flakes for package management
- Home Manager for user environment configuration
- devenv for development environment setup

### Directory Structure

```
dotfiles/
├── flake.nix                 # Main Nix flake configuration
├── devenv.nix               # devenv configuration
├── setup.sh                 # Setup script
├── docker/                  # Docker configuration
├── nix/                     # Nix configuration modules
│   ├── home-manager/        # Home Manager configurations
│   ├── hosts/               # Host-specific configurations
│   ├── nix-darwin/          # macOS system configurations
│   ├── packages/            # Custom packages
│   └── programs/            # Program configurations
│       ├── fish/            # Fish shell setup
│       ├── vscode/          # VS Code extensions
│       ├── git/             # Git configuration
│       └── [other programs] # Individual program configs
├── script/                  # Utility scripts
└── tasks/                   # Task runners
    ├── homebrew/            # Homebrew tasks
    └── nix/                 # Nix tasks
```

## Common Tasks

### Building the environment

```bash
./setup.sh
```

### Updating flake lock

```bash
devenv tasks run pkgs:update
```
