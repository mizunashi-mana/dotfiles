{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.pkgs.docker-client
        packages.pkgs.docker-buildx
        packages.pkgs.docker-credential-helpers
      ];
    }
  ];
}
