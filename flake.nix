{
  description = "The mizunashi-mana's dotfiles";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    };

    nixpkgs-stable = {
      url = "github:nixos/nixpkgs?ref=nixos-26.05";
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
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    _1password-shell-plugins = {
      url = "github:1Password/shell-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };

    mizunashi-mana-skills = {
      url = "github:mizunashi-mana/agent-skills";
      flake = false;
    };

    # NOTE: 最近のリビジョンは pnpm deps の固定ハッシュが darwin で一致せずビルドが失敗するため、
    # flake.lock で c314285 に据え置いている。lock を更新するときは hermes-agent を除外し、
    # upstream で直ったら据え置きを外す。
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
      nishiyamanomacbook-air = import ./nix/hosts/nishiyamanomacbook-air {
        inherit inputs;
      };
      nishiyamanomacbook-pro = import ./nix/hosts/nishiyamanomacbook-pro {
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
        nishiyamanomacbook-air.system
        nishiyamanomacbook-pro.system
        desktop-62r22ok.system
      ];

      imports = [
        treefmt-nix.flakeModule
      ];

      flake = {
        darwinConfigurations = {
          ${nishiyamanomacbook-air.hostname} = nishiyamanomacbook-air.darwinConfiguration;
          ${nishiyamanomacbook-pro.hostname} = nishiyamanomacbook-pro.darwinConfiguration;
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
