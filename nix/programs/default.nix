{
  pkgs,
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
    (import ./coreutils { inherit pkgs; })
    (import ./bash { inherit pkgs; })
    (import ./fish { inherit pkgs; })
    (import ./dircolors { inherit pkgs; })
    (import ./less { inherit pkgs; })
    (import ./man { inherit pkgs; })
    (import ./zoxide { inherit pkgs; })
    (import ./jq { inherit pkgs; })
    (import ./eza { inherit pkgs; })
    (import ./bat { inherit pkgs; })
    (import ./fzf { inherit pkgs; })
    (import ./lnav { inherit pkgs; })
    (import ./pigz { inherit pkgs; })
    (import ./nkf { inherit pkgs; })
    (import ./curl { inherit pkgs; })
    (import ./inetutils { inherit pkgs; })
    (import ./make { inherit pkgs; })
    (import ./sed { inherit pkgs; })
    (import ./direnv { inherit pkgs; })
    (import ./devenv { inherit pkgs; })
    (import ./ssh { inherit pkgs; })
    (import ./git { inherit pkgs; })
    (import ./emacs { inherit pkgs; })
    (import ./tmux { inherit pkgs; })
    (import ./gpg { inherit pkgs system; })
    (import ./password-store { inherit pkgs; })
    (import ./awscli { inherit pkgs; })
    (import ./gh { inherit pkgs; })
    (import ./colima { inherit pkgs; })
    (import ./docker { inherit pkgs; })
    (import ./1password { inherit pkgs inputs; })
    (import ./neovim { inherit pkgs; })
    (import ./z3 { inherit pkgs; })
    (import ./lha { inherit pkgs; })
    (import ./wget { inherit pkgs; })
    (import ./nmap { inherit pkgs; })
    (import ./arp-scan { inherit pkgs; })
    (import ./m4 { inherit pkgs; })
    (import ./getopt { inherit pkgs; })
    (import ./file { inherit pkgs; })
    (import ./gcc { inherit pkgs; })
    (import ./ruby { inherit pkgs; })
    (import ./poetry { inherit pkgs; })
    (import ./rustup { inherit pkgs; })
    (import ./gnuplot { inherit pkgs; })
    (import ./graphviz { inherit pkgs; })
    (import ./ffmpeg { inherit pkgs; })
    (import ./exiftool { inherit pkgs; })
    (import ./imagemagick { inherit pkgs; })
    (import ./ghostscript { inherit pkgs; })
    (import ./vagrant { inherit pkgs; })
    (import ./android-tools { inherit pkgs; })
    (import ./bc { inherit pkgs; })
    (import ./rsync { inherit pkgs; })
    (import ./w3m { inherit pkgs; })
    (import ./aerospace { inherit pkgs; })
    (import ./vscode { inherit pkgs; })
    (import ./google-chrome { inherit pkgs; })
    (import ./aquaskk { inherit pkgs; })
    (import ./ipe { inherit pkgs; })
    (import ./skimpdf { inherit pkgs; })
    (import ./zotero { inherit pkgs; })
    (import ./chatgpt { inherit pkgs; })
    (import ./sequel-ace { inherit pkgs; })
  ];
in
{
  inherit mkHomeManagerImports mkNixDarwinModules;

  homeManagerImports = mkHomeManagerImports { inherit programs; };
  nixDarwinModules = mkNixDarwinModules { inherit programs; };
}
