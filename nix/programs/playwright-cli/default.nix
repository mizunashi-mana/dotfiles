{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.playwright-cli
      ];
    }
  ];
}
