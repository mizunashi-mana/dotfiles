{
  ...
}:
{
  homeManagerImports = [
    {
      programs.git = {
        enable = true;
        lfs.enable = true;
        maintenance.enable = true;

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
  ];
}
