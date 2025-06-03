{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        pkgs.lnav
      ];
    }
  ];
}
