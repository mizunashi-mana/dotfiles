{ pkgs, system, ... }:
{
  programs.gpg = {
    enable = true;
  };

  home.packages = [
    (if system == "aarch64-darwin" then pkgs.pinentry_mac else pkgs.pinentry)
  ];
}
