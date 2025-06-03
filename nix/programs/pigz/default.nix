{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        pkgs.pigz
      ];
    }
  ];
}
