{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # https://devenv.sh/packages/
  packages = [ ];

  # https://devenv.sh/languages/
  languages = {
    nix.enable = true;
    shell.enable = true;
  };

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    nixfmt-rfc-style.enable = true;
    shellcheck.enable = true;
    yamlfmt.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
