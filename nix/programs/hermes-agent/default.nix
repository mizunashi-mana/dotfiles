{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.hermes-agent
      ];
    }
  ];
}
