{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # https://devenv.sh/packages/
  packages = [
    pkgs.nodePackages.node2nix
  ];

  # https://devenv.sh/scripts/
  scripts.lint-all = {
    exec = "prek run --all-files && nix flake check --all-systems";
  };
  scripts.update-pkgs = {
    exec = "nix flake update && ./script/node2nix-update.sh";
  };

  # https://devenv.sh/languages/
  languages.nix.enable = true;
  languages.shell.enable = true;

  # https://devenv.sh/git-hooks/
  git-hooks.hooks.actionlint.enable = true;
  git-hooks.hooks.nixfmt-rfc-style.enable = true;
  git-hooks.hooks.prettier.enable = true;
  git-hooks.hooks.pretty-format-json = {
    enable = true;
    settings = {
      autofix = true;
    };
  };
  git-hooks.hooks.shellcheck.enable = true;
  git-hooks.hooks.shfmt.enable = true;
  git-hooks.hooks.taplo.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
