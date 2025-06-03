{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.fish = {
        enable = true;
        shellInit = builtins.readFile ./init.fish;
      };

      xdg.configFile = {
        "fish/functions/" = {
          source = ./functions;
          recursive = true;
        };
      };
    }
  ];

  nixDarwinModules = [
    {
      programs.fish = {
        enable = true;
      };
    }
  ];
}
