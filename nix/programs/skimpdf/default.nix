{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        pkgs.skimpdf
      ];
    }
  ];
}
