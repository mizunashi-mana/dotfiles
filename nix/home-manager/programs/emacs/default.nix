{ pkgs }: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs.override {
      # ref: https://github.com/NixOS/nixpkgs/issues/395169
      withNativeCompilation = false;
    };
  };
}
