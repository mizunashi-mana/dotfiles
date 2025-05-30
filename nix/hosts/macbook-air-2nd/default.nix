{
  inputs,
}:
let
  nix-root-dir = ../..;

  hostname = "macbook-air-2nd";
  system = "aarch64-darwin";
  username = "workuser";
  homedir = "/Users/${username}";

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  inherit system hostname;

  darwinConfiguration = inputs.nix-darwin.lib.darwinSystem {
    inherit system pkgs;

    modules =
      let
        nixDarwinModules = import "${nix-root-dir}/nix-darwin" {
          inherit
            pkgs
            username
            homedir
            inputs
            ;

          extra-dock-persistent-apps = [
            {
              app = "/System/Applications/Music.app";
            }
          ];

          extra-brews = [ ];

          extra-casks = [
            "discord"
            "steam"
          ];
        };
      in
      (
        nixDarwinModules.modules
        ++ [
          {
            homebrew.masApps = {
              Kindle = 302584613;
            };

            home-manager.users.${username} = {
              programs.git = {
                userName = "Mizunashi Mana";
                userEmail = "contact@mizunashi.work";
              };

              imports =
                let
                  basicOptions = import "${nix-root-dir}/home-manager/options" {
                    inherit pkgs system;
                  };
                  basicPrograms = import "${nix-root-dir}/home-manager/programs" {
                    inherit pkgs system inputs;
                  };
                  extraGuiPrograms = import "${nix-root-dir}/home-manager/programs/extra-gui.nix" {
                    inherit pkgs system;
                  };

                  options = basicOptions.imports ++ [ ];
                  programs = (
                    basicPrograms.imports
                    ++ extraGuiPrograms.imports
                    ++ [
                      (import "${nix-root-dir}/home-manager/programs/texlive" {
                        inherit pkgs system;
                      })
                    ]
                  );
                in
                (programs ++ options);
            };
          }
        ]
      );
  };
}
