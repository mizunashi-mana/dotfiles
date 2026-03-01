{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.node-packages."@mizunashi_mana/mcp-html-artifacts-preview"
      ];
    }
  ];
}
