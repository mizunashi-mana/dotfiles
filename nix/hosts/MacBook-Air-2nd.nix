{
  nixpkgs,
  home-manager,
  nix-darwin,
}: let
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

    modules = [
      (import ../nix-darwin {
        inherit pkgs username homedir;
      })
      (import ../nix-darwin/homebrew-pkgs.nix {
        extraCasks = [
          "discord"
        ];
      })
      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = {
          home.stateVersion = "24.11";

          home.username = username;
          home.homeDirectory = homedir;

          programs.home-manager = {
            enable = true;
          };

          programs.git = {
            userName = "Mizunashi Mana";
            userEmail = "contact@mizunashi.work";
          };

          imports = let
            basicPrograms = import ../home-manager/programs {
              inherit pkgs;
            };
          in (basicPrograms.imports ++ [
            (import ../home-manager/programs/aerospace {
              inherit pkgs;
            })
            (import ../home-manager/programs/texlive {
              inherit pkgs;
            })
            (import ../home-manager/programs/vscode {
              inherit pkgs;
            })
          ]);
        };
      }
    ];
  };
}
