{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.node-packages."mcp-html-sync-server"
      ];
    }
  ];
}
