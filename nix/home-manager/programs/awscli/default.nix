{ pkgs, ... }:
{
  programs.awscli = {
    enable = true;
  };

  home.packages = [
    pkgs.ssm-session-manager-plugin
  ];
}
