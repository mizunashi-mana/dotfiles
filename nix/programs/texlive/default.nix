{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.texlive = {
        enable = true;
      };
    }
  ];
}
