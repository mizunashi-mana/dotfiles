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
      inputs
      ;
  };

  extra-programs = [
    (import "${nix-root-dir}/programs/gh" { inherit packages; })
    (import "${nix-root-dir}/programs/claude-code" { inherit packages; })
    (import "${nix-root-dir}/programs/gemini-cli" { inherit packages; })
    (import "${nix-root-dir}/programs/neovim" { inherit packages; })
    (import "${nix-root-dir}/programs/ripgrep" { inherit packages; })
    (import "${nix-root-dir}/programs/docker-client" { inherit packages; })
    (import "${nix-root-dir}/programs/agent-skills" { inherit packages inputs; })
    (import "${nix-root-dir}/programs/agent-skills-anthropic" { inherit packages inputs; })
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

        programs.git.settings = {
          user.name = "Mizunashi Mana";
          user.email = "contact@mizunashi.work";
        };
      }
    ];
  };
}
