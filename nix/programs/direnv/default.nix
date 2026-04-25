{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      programs.direnv = {
        enable = true;
        package = packages.pkgs-stable.direnv;
        nix-direnv.enable = true;
      };
    }
  ];
}
