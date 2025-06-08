{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      programs.texlive = {
        enable = true;
        # Avoid the fragile unstable package.
        packageSet = packages.pkgs-stable.texlive;
      };
    }
  ];
}
