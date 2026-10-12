{
  packages,
  ...
}:
let
  package = packages.pkgs-stable.zotero;
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
