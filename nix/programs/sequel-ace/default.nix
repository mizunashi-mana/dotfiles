{
  pkgs,
  ...
}:
{
  nixDarwinModules = [
    {
      homebrew.casks = [
        "sequel-ace"
      ];
    }
  ];
}
