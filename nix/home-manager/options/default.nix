{ pkgs, ... }:
let
  programs = import ../../programs {
    inherit pkgs;
  };
in {
  imports = [
    (import ./editorconfig {
      inherit pkgs;
    })
    (import ./home {
      inherit pkgs;
    })
  ] ++ programs.homeManagerImports;
}
