{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.pkgs.gws
      ];
    }
  ];
}
