{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.cc-voice-reporter
      ];
    }
  ];
}
