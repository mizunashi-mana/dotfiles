{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      programs.direnv = {
        enable = true;
        package = packages.pkgs.direnv;
        nix-direnv.enable = true;
      };
    }
  ];
}
