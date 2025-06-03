{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        pkgs.docker
        pkgs.docker-credential-helpers
      ];
    }
  ];
}
