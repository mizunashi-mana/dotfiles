{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.pkgs.agent-browser
      ];
    }
  ];
}
