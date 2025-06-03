{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.less = {
        enable = true;
      };
    }
  ];
}
