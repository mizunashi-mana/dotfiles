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
    (import ./zoxide { inherit packages; })
    (import ./jq { inherit packages; })
    (import ./eza { inherit packages; })
    (import ./bat { inherit packages; })
    (import ./fzf { inherit packages; })
    (import ./pigz { inherit packages; })
    (import ./nkf { inherit packages; })
    (import ./curl { inherit packages; })
    (import ./inetutils { inherit packages; })
    (import ./make { inherit packages; })
    (import ./sed { inherit packages; })
    (import ./direnv { inherit packages; })
    (import ./devenv { inherit packages; })
    (import ./ssh { inherit packages; })
    (import ./git { inherit packages; })
    (import ./emacs { inherit packages; })
    (import ./gpg { inherit packages system; })
    (import ./gh { inherit packages; })
    (import ./claude-code { inherit packages; })
    (import ./wget { inherit packages; })
    (import ./nmap { inherit packages; })
    (import ./getopt { inherit packages; })
    (import ./file { inherit packages; })
    (import ./bc { inherit packages; })
    (import ./rsync { inherit packages; })
  ];
in
{
  inherit mkHomeManagerImports mkNixDarwinModules mkNixosModules;

  homeManagerImports = mkHomeManagerImports { inherit programs; };
  nixDarwinModules = mkNixDarwinModules { inherit programs; };
  nixosModules = mkNixosModules { inherit programs; };
}
