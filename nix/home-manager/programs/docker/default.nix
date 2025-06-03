{ pkgs, ... }:
{
  home.packages = [
    pkgs.docker
    pkgs.docker-credential-helpers
  ];
}
