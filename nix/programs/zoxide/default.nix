{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.zoxide = {
        enable = true;
      };
    }
  ];
}
