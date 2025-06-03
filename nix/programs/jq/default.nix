{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.jq = {
        enable = true;
      };
    }
  ];
}
