{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.pkgs.kubernetes-helm
      ];
    }
  ];
}
