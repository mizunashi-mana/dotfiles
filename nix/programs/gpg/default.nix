{
  packages,
  system,
  ...
}:
{
  homeManagerImports = [
    {
      programs.gpg = {
        enable = true;
      };

      home.packages = [
        (if system == "aarch64-darwin" then packages.pkgs.pinentry_mac else packages.pkgs.pinentry)
      ];
    }
  ];
}
