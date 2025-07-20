{ packages, ... }:
let
  lib = packages.pkgs.lib;
in
{
  nix = {
    package = lib.mkDefault packages.pkgs.nix;
    extraOptions = builtins.readFile ./nix.conf;
  };
}
