{ pkgs, ... }:
{
  home.packages = [
    pkgs.imagemagick
    pkgs.poppler

    pkgs.ghostscript
  ];
}
