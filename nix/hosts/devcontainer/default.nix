{
  current-system,
  inputs,
  ...
}:
let
  nix-root-dir = ../..;

  hostname = "devcontainer";
  system = current-system;
  username = "vscode";
  homedir = "/home/${username}";

  packages = import "${nix-root-dir}/packages" {
    inherit inputs system;
  };

  home-manager = import "${nix-root-dir}/home-manager" {
    inherit inputs packages;
  };

  programs-common = import "${nix-root-dir}/programs/default-common.nix" {
    inherit
      packages
      system
      username
      homedir
      inputs
      ;
  };
in
{
  inherit system hostname;

  homeConfiguration = inputs.home-manager.lib.homeManagerConfiguration {
    inherit (packages) pkgs;

    modules = [
      {
        home.username = username;
        home.homeDirectory = homedir;

        imports = home-manager.imports ++ programs-common.homeManagerImports;

        programs.git = {
          userName = "Mizunashi Mana";
          userEmail = "contact@mizunashi.work";
        };
      }
    ];
  };
}
