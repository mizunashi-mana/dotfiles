{
  nixpkgs,
  home-manager,
  nix-darwin,
}: let
  nix-root-dir = ../..;

  hostname = "opl2401-013";
  system = "aarch64-darwin";
  username = "nishiyama_shun";
  homedir = "/Users/${username}";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in {
  inherit system hostname;

  darwinConfiguration = nix-darwin.lib.darwinSystem {
    inherit system pkgs;

    modules = let
      nixDarwinModules = import "${nix-root-dir}/nix-darwin" {
        inherit pkgs username homedir home-manager;

        extra-dock-persistent-apps = [
          {
            app = "/Applications/Slack.app";
          }
          {
            app = "/Applications/PhpStorm.app";
          }
        ];

        extra-brews = [
          "git-flow-avh"
        ];

        extra-casks = [
          "slack"
          "phpstorm"
        ];
      };
    in (nixDarwinModules.modules ++ [
      {
        home-manager.users.${username} = {
          programs.git = {
            userName = "Nishiyama Shun";
            userEmail = "nishiyama_shun@openlogi.com";
          };

          imports = let
            basicOptions = import "${nix-root-dir}/home-manager/options" {
              inherit pkgs system;
            };
            basicPrograms = import "${nix-root-dir}/home-manager/programs" {
              inherit pkgs system;
            };
            extraGuiPrograms = import "${nix-root-dir}/home-manager/programs/extra-gui.nix" {
              inherit pkgs system;
            };

            options = basicOptions.imports;
            programs = (basicPrograms.imports ++ extraGuiPrograms.imports);
          in (programs ++ options);
        };
      }
    ]);
  };
}
