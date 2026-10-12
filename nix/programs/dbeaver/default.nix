{
  packages,
  ...
}:
let
  package = packages.pkgs.dbeaver-bin;
in
{
  inherit package;

  homeManagerImports = [
    {
      home.packages = [
        package
      ];
    }
  ];
}
