{
  current-system,
  inputs,
  ...
}:
let
  nix-root-dir = ../..;

  hostname = "devcontainer-claude";
  system = current-system;
  username = "vscode";
  homedir = "/home/${username}";

  packages = import "${nix-root-dir}/packages" {
    inherit inputs system;
  };

  home-manager = import "${nix-root-dir}/home-manager" {
    inherit inputs packages;
    default-editor = "nvim";
  };

  programs = import "${nix-root-dir}/programs" {
    inherit
      packages
      system
      username
      homedir
      inputs
      ;
  };

  extra-programs = [
    (import "${nix-root-dir}/programs/gh" { inherit packages; })
    (import "${nix-root-dir}/programs/claude-code" { inherit packages; })
    (import "${nix-root-dir}/programs/gemini-cli" { inherit packages; })
    (import "${nix-root-dir}/programs/neovim" { inherit packages; })
    (import "${nix-root-dir}/programs/docker-client" { inherit packages; })
    (import "${nix-root-dir}/programs/playwright-mcp" { inherit packages; })
  ];
in
{
  inherit system hostname;

  homeConfiguration = inputs.home-manager.lib.homeManagerConfiguration {
    inherit (packages) pkgs;

    modules = [
      {
        home.username = username;
        home.homeDirectory = homedir;

        imports =
          home-manager.imports
          ++ programs.homeManagerImports
          ++ (programs.mkHomeManagerImports { programs = extra-programs; });

        programs.git = {
          userName = "Mizunashi Mana";
          userEmail = "contact@mizunashi.work";
        };
      }
    ];
  };
}
