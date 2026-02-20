{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.node-packages."@playwright/cli"
      ];
    }
  ];
}
