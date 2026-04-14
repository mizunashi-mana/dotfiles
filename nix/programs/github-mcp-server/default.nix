{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.pkgs.github-mcp-server
      ];
    }
  ];
}
