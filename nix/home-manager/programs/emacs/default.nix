{ pkgs, ... }: {
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.evil
      epkgs.evil-collection
      epkgs.magit
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
