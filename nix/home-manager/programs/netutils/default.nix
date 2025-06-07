{ pkgs, ... }:
{
  home.packages = [
    pkgs.inetutils
    pkgs.cacert
  ];
}
