{
  packages,
  ...
}:
{
  nixDarwinModules = [
    {
      environment.systemPackages = [
        packages.pkgs.docker
        packages.pkgs.docker-buildx
        packages.pkgs.docker-credential-helpers
      ];
    }
  ];

  homeManagerImports = [
    {
      home.packages = [
        packages.pkgs.docker
        packages.pkgs.docker-buildx
        packages.pkgs.docker-credential-helpers
      ];
    }
  ];
}
