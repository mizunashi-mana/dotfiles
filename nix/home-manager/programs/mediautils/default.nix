{ pkgs, ... }:
{
  home.packages = [
    pkgs.exiftool
    pkgs.ffmpeg
    pkgs.imagemagick
    pkgs.poppler

    pkgs.ghostscript
    pkgs.graphviz
  ];
}
