{ pkgs, programs, ... }:
{
  imports = [
    (import ./editorconfig {
      inherit pkgs;
    })
    (import ./home {
      inherit pkgs;
    })
  ] ++ programs.homeManagerImports;
}
