{
  packages,
  system,
  inputs,
  ...
}:
let
  default = import ./default.nix { inherit system inputs packages; };

  programs = [
    default
    (import ./zoxide { inherit packages; })
    (import ./jq { inherit packages; })
    (import ./eza { inherit packages; })
    (import ./bat { inherit packages; })
    (import ./fzf { inherit packages; })
    (import ./pigz { inherit packages; })
    (import ./nkf { inherit packages; })
    (import ./inetutils { inherit packages; })
    (import ./nmap { inherit packages; })
    (import ./getopt { inherit packages; })
    (import ./file { inherit packages; })
    (import ./bc { inherit packages; })
    (import ./rsync { inherit packages; })
    (import ./emacs { inherit packages; })
    (import ./neovim { inherit packages; })
    (import ./gh { inherit packages; })
    (import ./claude-code { inherit packages; })
    (import ./docker-client { inherit packages; })
    (import ./gemini-cli { inherit packages; })
  ];
in
{
  homeManagerImports = default.mkHomeManagerImports { inherit programs; };
  nixDarwinModules = default.mkNixDarwinModules { inherit programs; };
  nixosModules = default.mkNixosModules { inherit programs; };
}
