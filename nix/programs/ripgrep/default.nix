{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      programs.ripgrep = {
        enable = true;
      };
    }
  ];
}
