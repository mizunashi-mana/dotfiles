{ pkgs }: {
  /*
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
  };
  */

  home.packages = [
    pkgs.git
  ];
}
