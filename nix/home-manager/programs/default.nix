{ pkgs }: {
  imports = [
    (import ./coreutils {
      inherit pkgs;
    })
    (import ./netutils {
      inherit pkgs;
    })
    (import ./calcutils {
      inherit pkgs;
    })
    (import ./mediautils {
      inherit pkgs;
    })
    (import ./dircolors {
      inherit pkgs;
    })
    (import ./bash {
      inherit pkgs;
    })
    (import ./fish {
      inherit pkgs;
    })
    (import ./man {
      inherit pkgs;
    })
    (import ./less {
      inherit pkgs;
    })
    (import ./jq {
      inherit pkgs;
    })
    (import ./gpg {
      inherit pkgs;
    })
    (import ./git {
      inherit pkgs;
    })
    (import ./gh {
      inherit pkgs;
    })
    (import ./direnv {
      inherit pkgs;
    })
    (import ./ssh {
      inherit pkgs;
    })
    (import ./tmux {
      inherit pkgs;
    })
    (import ./neovim {
      inherit pkgs;
    })
    (import ./zoxide {
      inherit pkgs;
    })
    (import ./awscli {
      inherit pkgs;
    })
    (import ./ruby {
      inherit pkgs;
    })
  ];
}
