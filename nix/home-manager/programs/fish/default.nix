{ pkgs }:
{
  xdg.configFile = {
    "fish/functions/" = {
      source = ./functions;
      recursive = true;
    };
  };

  programs.fish = {
    enable = true;

    shellInit = builtins.readFile ./init.fish;
  };
}
