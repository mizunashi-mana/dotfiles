{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.bat = {
        enable = true;
      };
    }
  ];
}
