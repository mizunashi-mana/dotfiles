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
          ];

          extra-programs = [
            (import "${nix-root-dir}/programs/steam" { inherit pkgs; })
            (import "${nix-root-dir}/programs/texlive" { inherit pkgs; })
            (import "${nix-root-dir}/programs/kindle" { inherit pkgs; })
          ];
        };
      in
      (
        nixDarwinModules.modules
        ++ [
          {
            home-manager.users.${username} = {
              programs.git = {
                userName = "Mizunashi Mana";
                userEmail = "contact@mizunashi.work";
              };

              imports =
                let
                  basicPrograms = import "${nix-root-dir}/home-manager/programs" {
                    inherit pkgs system inputs;
                  };

                  programs = (basicPrograms.imports);
                in
                programs;
            };
          }
        ]
      );
  };
}
