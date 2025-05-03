{ pkgs }: {
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.evil
    ];
    extraConfig = builtins.readFile ./init.el;
  };

  services.emacs = {
    enable = true;
    client = {
      enable = true;
    };
  };
}
