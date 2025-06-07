{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        pkgs.nkf
      ];
    }
  ];
}
