{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    }
  ];
}
