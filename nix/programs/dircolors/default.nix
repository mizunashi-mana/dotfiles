{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.dircolors = {
        enable = true;
      };
    }
  ];
}
