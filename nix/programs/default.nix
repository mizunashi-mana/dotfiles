{
  pkgs,
  inputs,
  ...
}:
let
  mkHomeManagerImports =
    { programs }:
    builtins.concatLists (
      builtins.map (p: p.homeManagerImports) (builtins.filter (p: p ? homeManagerImports) programs)
    );

  mkNixDarwinModules =
    { programs }:
    builtins.concatLists (
      builtins.map (p: p.nixDarwinModules) (builtins.filter (p: p ? nixDarwinModules) programs)
    );

  programs = [
    (import ./fish { inherit pkgs; })
    (import ./zoxide { inherit pkgs; })
    (import ./colima { inherit pkgs; })
    (import ./1password { inherit pkgs inputs; })
    (import ./vagrant { inherit pkgs; })
    (import ./aerospace { inherit pkgs; })
  ];
in
{
  inherit mkHomeManagerImports mkNixDarwinModules;

  homeManagerImports = mkHomeManagerImports { inherit programs; };
  nixDarwinModules = mkNixDarwinModules { inherit programs; };
}
