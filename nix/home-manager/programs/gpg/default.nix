{ pkgs }: {
  programs.gpg = {
    enable = true;
  };

  home.packages = [
    pkgs.pinentry-gtk2
  ];
}
