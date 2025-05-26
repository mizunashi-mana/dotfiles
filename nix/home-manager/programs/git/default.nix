{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    maintenance.enable = true;

    delta = {
      enable = true;
      options = {
        navigate = true;
        dark = true;
        line-numbers = true;
        side-by-side = true;
      };
    };

    includes = [
      {
        path = "./conf.d/gitconfig";
      }
    ];
  };

  xdg.configFile = {
    "git/conf.d/" = {
      source = ./conf.d;
      recursive = true;
    };
  };
}
