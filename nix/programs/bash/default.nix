{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.bash = {
        enable = true;
      };
    }
  ];
}
