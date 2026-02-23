{
  packages,
  ...
}:
{
  homeManagerImports = [
    {
      home.packages = [
        packages.node-packages."@mizunashi_mana/cc-voice-reporter"
      ];
    }
  ];
}
