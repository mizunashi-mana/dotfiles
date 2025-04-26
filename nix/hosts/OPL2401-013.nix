{
  nixpkgs,
  home-manager,
  nix-darwin,
}: let
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

    modules = [
      (import ../nix-darwin {
        inherit pkgs username homedir;
      })
      (import ../nix-darwin/homebrew-pkgs.nix {
        extraCasks = [];
      })
      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = {
          home.stateVersion = "24.11";

          home.username = username;
          home.homeDirectory = homedir;

          programs.git = {
            userName = "Nishiyama Shun";
            userEmail = "nishiyama_shun@openlogi.com";
          };

          imports = let
            basicOptions = import ../home-manager/options {
              inherit pkgs;
            };
            basicPrograms = import ../home-manager/programs {
              inherit pkgs;
            };

            options = basicOptions.imports;
            programs = (basicPrograms.imports ++ [
              (import ../home-manager/programs/aerospace {
                inherit pkgs;
              })
              (import ../home-manager/programs/vscode {
                inherit pkgs;
              })
            ]);
          in (programs ++ options);
        };
      }
    ];
  };
}
