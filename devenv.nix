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
  scripts = {
    lint-all = {
      exec = "pre-commit run --all-files && nix flake check --all-systems";
    };
    update-pkgs = {
      exec = "nix flake update && ./script/node2nix-update.sh";
    };
  };

  # https://devenv.sh/languages/
  languages = {
    nix.enable = true;
    shell.enable = true;
  };

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    actionlint.enable = true;
    nixfmt-rfc-style.enable = true;
    prettier.enable = true;
    pretty-format-json = {
      enable = true;
      settings = {
        autofix = true;
      };
    };
    shellcheck.enable = true;
    shfmt.enable = true;
    taplo.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
