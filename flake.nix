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
  }: let
    macbookAir2nd = import ./nix/hosts/MacBook-Air-2nd {
      inherit nixpkgs home-manager nix-darwin;
    };
    opl2401013 = import ./nix/hosts/OPL2401-013 {
      inherit nixpkgs home-manager nix-darwin;
    };
  in flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      macbookAir2nd.system
      opl2401013.system
    ];

    imports = [ treefmt-nix.flakeModule ];

    flake = {
      darwinConfigurations = {
        ${macbookAir2nd.hostname} = macbookAir2nd.darwinConfiguration;
        ${opl2401013.hostname} = opl2401013.darwinConfiguration;
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
