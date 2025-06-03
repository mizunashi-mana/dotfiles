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
    (import ./bash { inherit pkgs; })
    (import ./fish { inherit pkgs; })
    (import ./zoxide { inherit pkgs; })
    (import ./jq { inherit pkgs; })
    (import ./less { inherit pkgs; })
    (import ./man { inherit pkgs; })
    (import ./eza { inherit pkgs; })
    (import ./bat { inherit pkgs; })
    (import ./devenv { inherit pkgs; })
    (import ./awscli { inherit pkgs; })
    (import ./colima { inherit pkgs; })
    (import ./docker { inherit pkgs; })
    (import ./1password { inherit pkgs inputs; })
    (import ./vagrant { inherit pkgs; })
    (import ./aerospace { inherit pkgs; })
    (import ./ipe { inherit pkgs; })
  ];
in
{
  inherit mkHomeManagerImports mkNixDarwinModules;

  homeManagerImports = mkHomeManagerImports { inherit programs; };
  nixDarwinModules = mkNixDarwinModules { inherit programs; };
}
