{
  pkgs,
  ...
}:
{
  nixDarwinModules = [
    {
      homebrew.casks = [
        "aquaskk"
      ];
    }
  ];
}
