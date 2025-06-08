{
  inputs,
}:
let
  nix-root-dir = ../..;

  hostname = "opl2401-013";
  system = "aarch64-darwin";
  username = "nishiyama_shun";
  homedir = "/Users/${username}";

  packages = import "${nix-root-dir}/nix/packages" {
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
              app = "/Applications/Slack.app";
            }
            {
              app = "/Applications/PhpStorm.app";
            }
          ];

          extra-programs = [
            (import "${nix-root-dir}/programs/phpstorm" { inherit packages; })
            (import "${nix-root-dir}/programs/slack" { inherit packages; })
          ];
        };
      in
      (
        nixDarwinModules.modules
        ++ [
          {
            homebrew.brews = [
              "git-flow-avh"
            ];

            home-manager.users.${username} = {
              programs.git = {
                userName = "Nishiyama Shun";
                userEmail = "nishiyama_shun@openlogi.com";
              };
            };
          }
        ]
      );
  };
}
