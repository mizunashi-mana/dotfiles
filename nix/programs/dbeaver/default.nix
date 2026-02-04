{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.pkgs.dbeaver-bin
      ];
    }
  ];
}
