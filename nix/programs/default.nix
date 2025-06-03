{
  pkgs,
  ...
}:
let
  programs = [
    (import ./fish { inherit pkgs; })
    (import ./colima { inherit pkgs; })
  ];
in {
  homeManagerImports = builtins.concatLists (
    builtins.map (p: p.homeManagerImports) (builtins.filter (p: p ? homeManagerImports) programs)
  );
  nixDarwinModules = builtins.concatLists (
    builtins.map (p: p.nixDarwinModules) (builtins.filter (p: p ? nixDarwinModules) programs)
  );
}
