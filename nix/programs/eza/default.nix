{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.eza = {
        enable = true;
      };
    }
  ];
}
