{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.pkgs.google-cloud-sdk
      ];
    }
  ];
}
