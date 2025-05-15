{
  nixpkgs,
  home-manager,
  nix-darwin,
}: let
  nix-root-dir = ../..;

  hostname = "macbook-air-2nd";
  system = "aarch64-darwin";
  username = "workuser";
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
        inherit pkgs username homedir;
      };
      homebrewPkgsModules = import "${nix-root-dir}/nix-darwin/homebrew-pkgs.nix" {
        inherit pkgs username homedir;
        extraBrews = [];
        extraCasks = [
          "discord"
          "steam"
        ];
      };
    in (nixDarwinModules.modules ++ homebrewPkgsModules.modules ++ [
      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = {
          home.stateVersion = "25.05";

          home.username = username;
          home.homeDirectory = homedir;

          programs.git = {
            userName = "Mizunashi Mana";
            userEmail = "contact@mizunashi.work";
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

            options = basicOptions.imports ++ [];
            programs = (basicPrograms.imports ++ extraGuiPrograms.imports ++ [
              (import "${nix-root-dir}/home-manager/programs/texlive" {
                inherit pkgs system;
              })
            ]);
          in (programs ++ options);
        };
      }
    ]);
  };
}
