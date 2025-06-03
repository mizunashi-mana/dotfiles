{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.man = {
        enable = true;
      };
    }
  ];
}
