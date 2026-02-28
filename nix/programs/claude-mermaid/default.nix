{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.node-packages."claude-mermaid"
      ];
    }
  ];
}
