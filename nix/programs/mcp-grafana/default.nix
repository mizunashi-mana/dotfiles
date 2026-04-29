{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.pkgs.mcp-grafana
      ];
    }
  ];
}
