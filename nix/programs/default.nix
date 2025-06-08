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
    (import ./lnav { inherit packages; })
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
    (import ./tmux { inherit packages; })
    (import ./gpg { inherit packages system; })
    (import ./password-store { inherit packages; })
    (import ./awscli { inherit packages; })
    (import ./gh { inherit packages; })
    (import ./claude-code { inherit packages; })
    (import ./colima { inherit packages; })
    (import ./docker { inherit packages; })
    (import ./1password { inherit packages inputs; })
    (import ./neovim { inherit packages; })
    (import ./z3 { inherit packages; })
    (import ./lha { inherit packages; })
    (import ./wget { inherit packages; })
    (import ./nmap { inherit packages; })
    (import ./arp-scan { inherit packages; })
    (import ./m4 { inherit packages; })
    (import ./getopt { inherit packages; })
    (import ./file { inherit packages; })
    (import ./gcc { inherit packages; })
    (import ./ruby { inherit packages; })
    (import ./poetry { inherit packages; })
    (import ./rustup { inherit packages; })
    (import ./gnuplot { inherit packages; })
    (import ./graphviz { inherit packages; })
    (import ./ffmpeg { inherit packages; })
    (import ./exiftool { inherit packages; })
    (import ./imagemagick { inherit packages; })
    (import ./ghostscript { inherit packages; })
    (import ./vagrant { inherit packages; })
    (import ./android-tools { inherit packages; })
    (import ./bc { inherit packages; })
    (import ./rsync { inherit packages; })
    (import ./w3m { inherit packages; })
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
  inherit mkHomeManagerImports mkNixDarwinModules;

  homeManagerImports = mkHomeManagerImports { inherit programs; };
  nixDarwinModules = mkNixDarwinModules { inherit programs; };
}
