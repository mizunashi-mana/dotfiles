{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.node-packages."@google/gemini-cli"
      ];
    }
  ];
}
