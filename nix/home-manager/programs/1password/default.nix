{ pkgs, inputs, ... }:
{
  imports = [
    inputs._1password-shell-plugins.hmModules.default
  ];

  programs._1password-shell-plugins = {
    enable = true;
    plugins = [
      pkgs.gh
      pkgs.cachix
    ];
  };
}
