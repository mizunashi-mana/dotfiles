{
  packages,
  system,
  inputs,
  ...
}:
let
  default = import ./default.nix { inherit system inputs packages; };

  programs = [
    (import ./neovim { inherit packages; })
    (import ./z3 { inherit packages; })
    (import ./gcc { inherit packages; })
    (import ./lnav { inherit packages; })
    (import ./m4 { inherit packages; })
    (import ./arp-scan { inherit packages; })
    (import ./tmux { inherit packages; })
    (import ./awscli { inherit packages; })
    (import ./lha { inherit packages; })
    (import ./gnuplot { inherit packages; })
    (import ./graphviz { inherit packages; })
    (import ./ffmpeg { inherit packages; })
    (import ./exiftool { inherit packages; })
    (import ./imagemagick { inherit packages; })
    (import ./ghostscript { inherit packages; })
    (import ./ruby { inherit packages; })
    (import ./poetry { inherit packages; })
    (import ./rustup { inherit packages; })
    (import ./docker { inherit packages; })
    (import ./android-tools { inherit packages; })
    (import ./password-store { inherit packages; })
    (import ./w3m { inherit packages; })
    (import ./colima { inherit packages; })
    (import ./1password { inherit packages inputs; })
    (import ./vagrant { inherit packages; })
    (import ./aerospace { inherit packages; })
    (import ./vscode { inherit packages; })
    (import ./google-chrome { inherit packages; })
    (import ./aquaskk { inherit packages; })
    (import ./ipe { inherit packages; })
    (import ./skimpdf { inherit packages; })
    (import ./zotero { inherit packages; })
    (import ./chatgpt { inherit packages; })
    (import ./sequel-ace { inherit packages; })
  ];
in
{
  homeManagerImports = default.mkHomeManagerImports { inherit programs; };
  nixDarwinModules = default.mkNixDarwinModules { inherit programs; };
  nixosModules = default.mkNixosModules { inherit programs; };
}
