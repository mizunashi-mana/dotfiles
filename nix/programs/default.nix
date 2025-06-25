{
  packages,
  system,
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

  mkNixosModules =
    { programs }:
    builtins.concatLists (
      builtins.map (p: p.nixosModules) (builtins.filter (p: p ? nixosModules) programs)
    );

  programs = [
    (import ./coreutils { inherit packages; })
    (import ./bash { inherit packages; })
    (import ./fish { inherit packages; })
    (import ./dircolors { inherit packages; })
    (import ./less { inherit packages; })
    (import ./man { inherit packages; })
    (import ./curl { inherit packages; })
    (import ./make { inherit packages; })
    (import ./sed { inherit packages; })
    (import ./direnv { inherit packages; })
    (import ./devenv { inherit packages; })
    (import ./ssh { inherit packages; })
    (import ./git { inherit packages; })
    (import ./gpg { inherit packages system; })
    (import ./wget { inherit packages; })
  ];
in
{
  inherit mkHomeManagerImports mkNixDarwinModules mkNixosModules;

  homeManagerImports = mkHomeManagerImports { inherit programs; };
  nixDarwinModules = mkNixDarwinModules { inherit programs; };
  nixosModules = mkNixosModules { inherit programs; };
}
