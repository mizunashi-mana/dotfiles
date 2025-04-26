{ pkgs }: {
  # WIP
  programs.emacs = {
    enable = true;
    package = pkgs.emacs.override {
      # ref: https://github.com/NixOS/nixpkgs/issues/395169
      withNativeCompilation = false;
    };
    extraConfig = builtins.readFile ./init.el;
    extraPackages = epkgs: [
      epkgs.evil
    ];
  };
}
