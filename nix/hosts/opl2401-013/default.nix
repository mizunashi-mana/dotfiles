{
  inputs,
}:
let
  nix-root-dir = ../..;

  hostname = "opl2401-013";
  system = "aarch64-darwin";
  username = "nishiyama_shun";
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

          extra-brews = [
            "git-flow-avh"
          ];

          extra-programs = [
            (import "${nix-root-dir}/programs/phpstorm" { inherit pkgs; })
            (import "${nix-root-dir}/programs/slack" { inherit pkgs; })
          ];
        };
      in
      (
        nixDarwinModules.modules
        ++ [
          {
            home-manager.users.${username} = {
              programs.git = {
                userName = "Nishiyama Shun";
                userEmail = "nishiyama_shun@openlogi.com";
              };

              imports =
                let
                  basicPrograms = import "${nix-root-dir}/home-manager/programs" {
                    inherit pkgs system inputs;
                  };

                  programs = basicPrograms.imports;
                in
                programs;
            };
          }
        ]
      );
  };
}
