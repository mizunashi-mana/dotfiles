{
  pkgs,
  system,
  inputs,
  ...
}:
{
  imports = [
    ({
      programs.home-manager = {
        enable = true;
      };
    })
    (import ./coreutils {
      inherit pkgs system;
    })
    (import ./netutils {
      inherit pkgs system;
    })
    (import ./calcutils {
      inherit pkgs system;
    })
    (import ./mediautils {
      inherit pkgs system;
    })
    (import ./compressutils {
      inherit pkgs system;
    })
    (import ./dircolors {
      inherit pkgs system;
    })
    (import ./bash {
      inherit pkgs system;
    })
    (import ./fish {
      inherit pkgs system;
    })
    (import ./man {
      inherit pkgs system;
    })
    (import ./less {
      inherit pkgs system;
    })
    (import ./jq {
      inherit pkgs system;
    })
    (import ./gpg {
      inherit pkgs system;
    })
    (import ./git {
      inherit pkgs system;
    })
    (import ./gh {
      inherit pkgs system;
    })
    (import ./direnv {
      inherit pkgs system;
    })
    (import ./ssh {
      inherit pkgs system;
    })
    (import ./tmux {
      inherit pkgs system;
    })
    (import ./emacs {
      inherit pkgs system;
    })
    (import ./neovim {
      inherit pkgs system;
    })
    (import ./zoxide {
      inherit pkgs system;
    })
    (import ./fzf {
      inherit pkgs system;
    })
    (import ./awscli {
      inherit pkgs system;
    })
    (import ./ruby {
      inherit pkgs system;
    })
    (import ./python {
      inherit pkgs system;
    })
    (import ./rust {
      inherit pkgs system;
    })
    (import ./password-store {
      inherit pkgs system;
    })
    (import ./android-tools {
      inherit pkgs system;
    })
    (import ./lnav {
      inherit pkgs system;
    })
    (import ./bat {
      inherit pkgs system;
    })
    (import ./eza {
      inherit pkgs system;
    })
    (import ./pigz {
      inherit pkgs system;
    })
    (import ./1password {
      inherit pkgs system inputs;
    })
  ];
}
