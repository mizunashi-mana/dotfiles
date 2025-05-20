{
  description = "The mizunashi-mana's dotfiles";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixpkgs-25.05-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    flake-parts,
    treefmt-nix,
    nixpkgs,
    home-manager,
    nix-darwin,
    ...
  }: let
    macbook-air-2nd = import ./nix/hosts/macbook-air-2nd {
      inherit nixpkgs home-manager nix-darwin;
    };
    nishiyama-shunnomacbook-pro = import ./nix/hosts/nishiyama-shunnomacbook-pro {
      inherit nixpkgs home-manager nix-darwin;
    };
  in flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      macbook-air-2nd.system
      nishiyama-shunnomacbook-pro.system
    ];

    imports = [
      treefmt-nix.flakeModule
    ];

    flake = {
      darwinConfigurations = {
        ${macbook-air-2nd.hostname} = macbook-air-2nd.darwinConfiguration;
        ${nishiyama-shunnomacbook-pro.hostname} = nishiyama-shunnomacbook-pro.darwinConfiguration;
      };
    };

    perSystem =
      { ... }:
      {
        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            actionlint.enable = true;
            nixfmt.enable = true;
            taplo.enable = true;
            jsonfmt.enable = true;
            yamlfmt.enable = true;
            fish_indent.enable = true;
            stylua.enable = true;
            shfmt.enable = true;
            prettier.enable = true;
          };
        };
      };
  };
}
