{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.aerospace = {
        enable = true;
      };
    }
  ];
}
