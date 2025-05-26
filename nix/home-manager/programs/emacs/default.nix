{ pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.evil
      epkgs.evil-collection
    ];
    extraConfig = ''(load-file "~/.emacs.d/init.el")'';
  };

  home.file = {
    ".emacs.d/init.el" = {
      text = builtins.readFile ./init.el;
    };
  };

  services.emacs = {
    enable = true;
    client = {
      enable = true;
    };
  };
}
