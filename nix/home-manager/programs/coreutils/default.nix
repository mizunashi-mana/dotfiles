{ pkgs, ... }: {
  home.packages = [
    pkgs.coreutils
    pkgs.gcc
    pkgs.getopt
    pkgs.gettext
    pkgs.gnumake
    pkgs.gnum4
    pkgs.gnused
    pkgs.nkf
  ];
}
