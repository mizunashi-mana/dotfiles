{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.pkgs.docker
        packages.pkgs.docker-credential-helpers
      ];
    }
  ];
}
