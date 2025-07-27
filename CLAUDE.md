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
├── setup.sh                 # Main setup script
├── nix/                     # Nix configuration modules
│   ├── home-manager/        # Home Manager configurations
│   ├── hosts/               # Host-specific configurations
│   ├── nix-darwin/          # macOS system configurations
│   ├── node2nix/            # Node.js package management
│   │   └── node-packages.json # Package declarations
│   └── programs/            # Program configurations
│       ├── claude-code/     # Claude Code configuration
│       │   └── settings.json # Claude Code settings
│       ├── fish/            # Fish shell setup
│       ├── git/             # Git configuration
│       └── vscode/          # VS Code extensions
├── script/                  # Utility scripts
│   └── node2nix-update.sh   # Updates node packages
└── tasks/                   # Task runners
```

## Common Tasks

### Initial Setup

```bash
# Run the main setup script
./setup.sh
```

### Development Environment

```bash
# Enter development shell
devenv shell

# Update all packages and flake lock
devenv shell update-pkgs

# Run linting and checks
devenv shell lint-all
```

### Node.js Package Management

This repository uses `node2nix` to manage Node.js packages in a Nix-compatible way.

```bash
# Update node packages (after modifying node-packages.json)
./script/node2nix-update.sh

# Or manually from the node2nix directory
cd nix/node2nix
node2nix --input node-packages.json
```

To add a new Node.js package:

1. Edit `nix/node2nix/node-packages.json`
2. Run `./script/node2nix-update.sh`
3. Commit the updated files

### Host-Specific Builds

```bash
# Build for macOS (Darwin)
darwin-rebuild switch --flake .#macbook-air-2nd

# Build for NixOS
sudo nixos-rebuild switch --flake .#desktop-62r22ok

# Build home-manager configuration
home-manager switch --flake .
```

### Updating Dependencies

```bash
# Update specific flake input
nix flake update <input-name>

# Update all flake inputs
nix flake update

# Update devenv lock
devenv update
```

## Claude Code Configuration

This repository includes Claude Code settings in `nix/programs/claude-code/settings.json`. The configuration includes:

- Custom tool permissions and settings
- MCP (Model Context Protocol) integrations
- Development workflow optimizations

The settings are automatically applied when using Claude Code in this repository.

## Git Configuration

Git is configured through `nix/programs/git/` with:

- Global gitconfig settings
- Global gitignore patterns
- Custom aliases and hooks

## Development Tips

### Working with Nix

- Always use `devenv shell` for development to ensure consistent tooling
- Run `nix flake check` before committing to validate the configuration
- Use `nix-tree` to explore package dependencies

### Troubleshooting

```bash
# Check Nix configuration
nix doctor

# Garbage collect old generations
nix-collect-garbage -d

# Repair Nix store
nix-store --verify --check-contents --repair
```

## Important Files

- `flake.nix`: Main entry point for the Nix configuration
- `devenv.nix`: Development environment setup
- `setup.sh`: Bootstrap script for new machines
- `nix/hosts/*/default.nix`: Host-specific configurations
- `nix/programs/*/default.nix`: Individual program configurations
