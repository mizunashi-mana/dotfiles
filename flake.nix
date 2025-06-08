{
  description = "The mizunashi-mana's dotfiles";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
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

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      treefmt-nix,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      macbook-air-2nd = import ./nix/hosts/macbook-air-2nd {
        inherit inputs;
      };
      opl2401-013 = import ./nix/hosts/opl2401-013 {
        inherit inputs;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        macbook-air-2nd.system
        opl2401-013.system
      ];

      imports = [
        treefmt-nix.flakeModule
      ];

      flake = {
        darwinConfigurations = {
          ${macbook-air-2nd.hostname} = macbook-air-2nd.darwinConfiguration;
          ${opl2401-013.hostname} = opl2401-013.darwinConfiguration;
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
