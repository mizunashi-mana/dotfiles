{
  packages,
  ...
}:
let
  package = packages.pkgs.raycast;
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
