{
  inputs,
}:
let
  nix-root-dir = ../..;

  hostname = "macbook-air-2nd";
  system = "aarch64-darwin";
  username = "workuser";
  homedir = "/Users/${username}";

  packages = import "${nix-root-dir}/packages" {
    inherit inputs system;
  };
in
{
  inherit system hostname;

  darwinConfiguration = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    inherit (packages) pkgs;

    modules =
      let
        nixDarwinModules = import "${nix-root-dir}/nix-darwin" {
          inherit
            packages
            system
            username
            homedir
            inputs
            ;

          extra-dock-persistent-apps = [
            {
              app = "/System/Applications/Music.app";
            }
          ];

          extra-programs = [
            (import "${nix-root-dir}/programs/steam" { inherit packages; })
            (import "${nix-root-dir}/programs/texlive" { inherit packages; })
            (import "${nix-root-dir}/programs/kindle" { inherit packages; })
            (import "${nix-root-dir}/programs/discord" { inherit packages; })
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
            };
          }
        ]
      );
  };
}
