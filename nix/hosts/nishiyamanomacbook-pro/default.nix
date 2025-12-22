{
  inputs,
}:
let
  nix-root-dir = ../..;

  hostname = "nishiyamanomacbook-pro";
  system = "aarch64-darwin";
  username = "nishiyama-shun";
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
              app = "/Applications/Slack.app";
            }
            {
              app = "/Applications/PhpStorm.app";
            }
            {
              app = "/Applications/Figma.app";
            }
          ];

          extra-programs = [
            (import "${nix-root-dir}/programs/phpstorm" { inherit packages; })
            (import "${nix-root-dir}/programs/slack" { inherit packages; })
            (import "${nix-root-dir}/programs/figma" { inherit packages; })
            (import "${nix-root-dir}/programs/docker-desktop" { inherit packages; })
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
              programs.git.settings = {
                user.name = "Nishiyama Shun";
                user.email = "nishiyama_shun@openlogi.com";
              };
            };
          }
        ]
      );
  };
}
