{
  description = "The mizunashi-mana's dotfiles";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    };

    nixpkgs-stable = {
      url = "github:nixos/nixpkgs?ref=nixos-25.05";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    _1password-shell-plugins = {
      url = "github:1Password/shell-plugins";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      flake-parts,
      treefmt-nix,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      current-system = (if builtins ? currentSystem then builtins.currentSystem else "aarch64-linux");
      macbook-air-2nd = import ./nix/hosts/macbook-air-2nd {
        inherit inputs;
      };
      opl2401-013 = import ./nix/hosts/opl2401-013 {
        inherit inputs;
      };
      devcontainer = import ./nix/hosts/devcontainer {
        inherit current-system inputs;
      };
      devcontainer-claude = import ./nix/hosts/devcontainer-claude {
        inherit current-system inputs;
      };
      desktop-62r22ok = import ./nix/hosts/desktop-62r22ok {
        inherit inputs;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        devcontainer.system
        devcontainer-claude.system
        macbook-air-2nd.system
        opl2401-013.system
        desktop-62r22ok.system
      ];

      imports = [
        treefmt-nix.flakeModule
      ];

      flake = {
        darwinConfigurations = {
          ${macbook-air-2nd.hostname} = macbook-air-2nd.darwinConfiguration;
          ${opl2401-013.hostname} = opl2401-013.darwinConfiguration;
        };

        homeConfigurations = {
          ${devcontainer.hostname} = devcontainer.homeConfiguration;
          ${devcontainer-claude.hostname} = devcontainer-claude.homeConfiguration;
          ${desktop-62r22ok.hostname} = desktop-62r22ok.homeConfiguration;
        };
      };

      perSystem =
        { ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              fish_indent.enable = true;
            };
          };
        };
    };
}
