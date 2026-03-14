{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.pkgs-stable.devenv
      ];
    }
  ];
}
