{
  pkgs,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        pkgs.zotero
      ];
    }
  ];
}
