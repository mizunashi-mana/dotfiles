{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.fzf = {
        enable = true;
      };
    }
  ];
}
